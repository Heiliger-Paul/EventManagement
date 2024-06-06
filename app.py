from flask import Flask, render_template, request, redirect, url_for, flash, session
import mysql.connector

app = Flask(__name__)
app.secret_key = 'your_secret_key'

def get_db_connection():
    return mysql.connector.connect(
        host="localhost",
        port="3307",
        user="root",
        password="",
        database="gonfer"
    )

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/auth', methods=['GET', 'POST'])
def auth():
    if request.method == 'POST':
        form_type = request.form['form_type']
        
        if form_type == 'login':
            email = request.form['email']
            password = request.form['password']
            
            conn = get_db_connection()
            cursor = conn.cursor(dictionary=True)
            cursor.execute("SELECT * FROM Owner WHERE Email = %s", (email,))
            user = cursor.fetchone()
            cursor.close()
            conn.close()
            
            if user and user['Password'] == password:
                session['user_id'] = user['OwnerID']
                session['email'] = user['Email']
                flash('Login successful', 'success')
                return redirect(url_for('event_list'))
            elif email == 'admin@example.com' and password == 'adminpassword':
                return redirect(url_for('admin'))
            else:
                flash('Invalid credentials, try again', 'danger')
                return redirect(url_for('auth'))

        elif form_type == 'register':
            fullname = request.form['fullname']
            email = request.form['email']
            phone = request.form['phone']
            password = request.form['password']
            
            conn = get_db_connection()
            cursor = conn.cursor()
            try:
                cursor.execute("INSERT INTO Owner (FullName, Email, Phone, Password) VALUES (%s, %s, %s, %s)",
                               (fullname, email, phone, password))
                conn.commit()
                flash('Registration successful', 'success')
                return redirect(url_for('registerForm'))
            except mysql.connector.Error as err:
                flash(f'Error: {err}', 'danger')
            finally:
                cursor.close()
                conn.close()
    
    return render_template('auth.html')

@app.route('/admin')
def admin():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute('''
        SELECT ce.EventID, ce.Name AS EventName, o.Email AS OwnerEmail
        FROM ConferenceEvent ce
        JOIN Owner o ON ce.OwnerID = o.OwnerID
    ''')
    events = cursor.fetchall()

    cursor.execute('SELECT EmployeeID, Name FROM Employee')
    employees = cursor.fetchall()

    cursor.close()
    conn.close()
    
    return render_template('admin.html', events=events, employees=employees)

@app.route('/event_list')
def event_list():
    if 'user_id' not in session:
        flash('You must be logged in to view events', 'danger')
        return redirect(url_for('auth'))
    
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    cursor.execute('''
        SELECT 
            ce.EventID,
            ce.Name AS EventName, 
            ce.Type AS EventType, 
            ce.EventDate, 
            ce.StartTime, 
            ce.EndTime, 
            ce.NumberOfAttendees, 
            ch.Name AS ConferenceHall, 
            ch.Price AS HallPrice, 
            ch.Size AS HallSize,
            e.Name AS EventManager
        FROM ConferenceEvent ce
        JOIN Event_Hall eh ON ce.EventID = eh.EventID
        JOIN ConferenceHall ch ON eh.HallID = ch.HallID
        LEFT JOIN Event_Employee ee ON ce.EventID = ee.EventID
        LEFT JOIN Employee e ON ee.EmployeeID = e.EmployeeID
        WHERE ce.OwnerID = %s
    ''', (session['user_id'],))
    
    events = cursor.fetchall()
    cursor.close()
    conn.close()
    
    return render_template('event-list.html', events=events)

@app.route('/registerForm')
def registerForm():
    return render_template('registerForm.html')

@app.route('/logout')
def logout():
    session.pop('user_id', None)
    session.pop('email', None)
    flash('You have been logged out', 'info')
    return redirect(url_for('auth'))

@app.route('/event_form')
def event_form():
    if 'user_id' not in session:
        flash('You must be logged in to create an event', 'danger')
        return redirect(url_for('auth'))
    return render_template('event_form.html')

@app.route('/submit_event', methods=['POST'])
def submit_event():
    if 'user_id' not in session:
        flash('You must be logged in to submit an event', 'danger')
        return redirect(url_for('auth'))

    name = request.form['event_name']
    event_type = request.form['event_type']
    event_date = request.form['event_date']
    start_time = request.form['start_time']
    end_time = request.form['end_time']
    number_of_attendees = request.form['number_of_attendees']
    hall_name = request.form['hall_name']
    owner_id = session['user_id']

    conn = get_db_connection()
    cursor = conn.cursor()
    
    cursor.execute('''
        INSERT INTO ConferenceEvent (Name, Type, EventDate, StartTime, EndTime, NumberOfAttendees, OwnerID, AdminEmployeeID)
        VALUES (%s, %s, %s, %s, %s, %s, %s, 
                (SELECT AdminEmployeeID FROM AdminEmployee LIMIT 1))
    ''', (name, event_type, event_date, start_time, end_time, number_of_attendees, owner_id))
    
    event_id = cursor.lastrowid

    cursor.execute('''
        INSERT INTO Event_Hall (EventID, HallID)
        VALUES (%s, (SELECT HallID FROM ConferenceHall WHERE Name = %s))
    ''', (event_id, hall_name))
    
    conn.commit()
    cursor.close()
    conn.close()
    
    flash('Event created successfully', 'success')
    return redirect(url_for('registerForm'))

@app.route('/assign_employee', methods=['POST'])
def assign_employee():
    event_id = request.form['event_id']
    employee_id = request.form['employee_id']
    
    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute('''
        INSERT INTO Event_Employee (EventID, EmployeeID)
        VALUES (%s, %s)
    ''', (event_id, employee_id))
    
    conn.commit()
    cursor.close()
    conn.close()
    
    flash('Employee assigned successfully', 'success')
    return redirect(url_for('admin'))

@app.route('/hall_list')
def hall_list():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute('SELECT * FROM ConferenceHall')
    halls = cursor.fetchall()

    cursor.close()
    conn.close()
    
    return render_template('hall_list.html', halls=halls)

@app.route('/employee_list')
def employee_list():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute('SELECT * FROM Employee')
    employees = cursor.fetchall()

    cursor.close()
    conn.close()
    
    return render_template('employee_list.html', employees=employees)

@app.route('/update_event', methods=['POST'])
def update_event():
    event_id = request.form['event_id']
    updates = {}
    
    if 'event_name' in request.form:
        updates['Name'] = request.form['event_name']
    if 'event_type' in request.form:
        updates['Type'] = request.form['event_type']
    if 'conference_hall' in request.form:
        updates['ConferenceHall'] = request.form['conference_hall']
    if 'event_date' in request.form:
        updates['EventDate'] = request.form['event_date']
    if 'start_time' in request.form:
        updates['StartTime'] = request.form['start_time']
    if 'end_time' in request.form:
        updates['EndTime'] = request.form['end_time']
    if 'number_of_attendees' in request.form:
        updates['NumberOfAttendees'] = request.form['number_of_attendees']
    
    set_clause = ', '.join(f"{key} = %s" for key in updates.keys())
    values = list(updates.values())
    values.append(event_id)
    
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute(f"UPDATE ConferenceEvent SET {set_clause} WHERE EventID = %s", values)
    conn.commit()
    cursor.close()
    conn.close()
    
    flash('Event updated successfully', 'success')
    return redirect(url_for('event_list'))

@app.route('/delete_event', methods=['POST'])
def delete_event():
    event_id = request.form['event_id']
    
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("DELETE FROM ConferenceEvent WHERE EventID = %s", (event_id,))
    cursor.execute("DELETE FROM Event_Hall WHERE EventID = %s", (event_id,))
    cursor.execute("DELETE FROM Event_Employee WHERE EventID = %s", (event_id,))
    conn.commit()
    cursor.close()
    conn.close()
    
    flash('Event deleted successfully', 'success')
    return redirect(url_for('event_list'))


if __name__ == '__main__':
    app.run(debug=True)