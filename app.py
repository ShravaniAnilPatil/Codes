from flask import Flask, render_template_string, request, redirect, url_for

app = Flask(__name__)

# Home route
@app.route("/")
def hello_world():
    return "<p>Hello, World!</p>"

# Contact route with form
@app.route("/contact", methods=["GET", "POST"])
def contact_page():
    if request.method == "POST":
        # Get the form data
        name = request.form["name"]
        email = request.form["email"]
        phone = request.form["phone"]
        address = request.form["address"]
        message = request.form["message"]
        
        # Redirect to the thank you page, passing the data via query parameters
        return redirect(url_for("thanks_page", name=name, email=email, phone=phone, address=address, message=message))
    
    return render_template_string("""
        <h1>Contact Us</h1>
        <form method="POST">
            <label for="name">Name:</label><br>
            <input type="text" id="name" name="name" required><br><br>
            
            <label for="email">Email:</label><br>
            <input type="email" id="email" name="email" required><br><br>
            
            <label for="phone">Phone Number:</label><br>
            <input type="text" id="phone" name="phone"><br><br>
            
            <label for="address">Address:</label><br>
            <input type="text" id="address" name="address"><br><br>
            
            <label for="message">Message:</label><br>
            <textarea id="message" name="message" rows="4" required></textarea><br><br>
            
            <input type="submit" value="Submit">
        </form>
    """)

# Thank you page to display the submitted information
@app.route("/thank-you")
def thanks_page():
    name = request.args.get("name")
    email = request.args.get("email")
    phone = request.args.get("phone")
    address = request.args.get("address")
    message = request.args.get("message")
    
    return render_template_string("""
        <h1>Thank You!</h1>
        <p>Thank you, {{ name }}. We have received your information.</p>
        <p><strong>Email:</strong> {{ email }}</p>
        <p><strong>Phone Number:</strong> {{ phone }}</p>
        <p><strong>Address:</strong> {{ address }}</p>
        <p><strong>Message:</strong></p>
        <p>{{ message }}</p>
    """, name=name, email=email, phone=phone, address=address, message=message)

if __name__ == "__main__":
    app.run(debug=True)
