# Event Management Website

This project is an Event Management Website built using Flask, MySQL, HTML, CSS, JavaScript, Bootstrap, jQuery, and Slider.js. The website allows users to create, manage, and view events seamlessly.

## Installation

To get started with this project, follow the steps below:

1. **Clone the repository:**
   ```sh
   git clone https://github.com/Heiliger-Paul/event-management-website.git
   cd event-management-website
   ```

2. **Install the required dependencies:**
   ```sh
   pip install -r requirements.txt
   ```

3. **Setup the MySQL database:**
   - Ensure you have MySQL installed and running.
   - Create a database named `event_management`.
   - Execute the SQL commands provided in the `database.sql` file to create the necessary tables and insert sample data.

4. **Run the Flask application:**
   ```sh
   flask run
   ```

   The application will be accessible at `http://127.0.0.1:5000/`.

## Technologies Used

- **Flask:** Used as the server-side language for handling HTTP requests, routing, and rendering templates.
- **MySQL:** Used as the backend database to store event-related data.
- **Bootstrap:** Used for styling and responsive design.
- **jQuery:** Used for DOM manipulation and handling AJAX requests.
- **Slider.js:** Used to create interactive sliders on the website.
- **HTML/CSS/JS:** Standard web technologies used for structure, styling, and interactivity.

## Project Structure

```
event-management-website/
│
├── static/
│   ├── css/
│   ├── js/
│   └── images/
│
├── templates/
│
├── app.py
├── requirements.txt
└── bishoftu.sql
```

## Database Setup

The `database.sql` file contains the SQL commands to create the necessary tables and insert sample data for the Event Management Website. You can execute these commands using your preferred MySQL client or command line tool.

## Usage

- Visit the home page to see a list of upcoming events.
- Use the navigation menu to create a new event or view details of existing events.
- Utilize the interactive sliders on the event pages to explore event images or other multimedia content.

## Contributions

Contributions to the project are welcome. Feel free to open issues or submit pull requests on the [GitHub repository](https://github.com/Heiliger-Paul/event-management-website).

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more information.
