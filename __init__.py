from flask import Flask, request, render_template, url_for, redirect, session
import sqlite3

conn = sqlite3.connect('database.db')
app = Flask(__name__)
app.config['SECRET_KEY'] = '5791628bb0b13ce0c676dfde280ba245'


def dict_factory(cursor, row):
    d = {}
    for idx, col in enumerate(cursor.description):
        d[col[0]] = row[idx]
    return d


@app.route("/")
@app.route("/login", methods=['POST', 'GET'])
def login():
    if request.method == "POST":
        # Grab "users" and "passwords" from database
        conn = sqlite3.connect('database.db')
        conn.row_factory = dict_factory
        c = conn.cursor()
        c.execute("SELECT landlordID, firstName FROM Landlord")
        user_storage = c.fetchall()

        # Store user-password combinations in python dictionary
        users = {}
        for user in user_storage:
            users[user['firstName']] = str(user['landlordID'])
        print(users)  # for debugging

        # Grab form data from login page
        username = request.form['username']
        pwd = request.form['pwd']

        # Check form data for a user-password combination match
        if username in users:
            if users[username] == pwd:
                session['user'] = username
                session['id'] = users[username]
                return home()
            else:
                return render_template('log-in.html', info='invalid password')
        else:
            return render_template('log-in.html', info='invalid user')
    else:
        return render_template('log-in.html')


@app.route("/logout")
def logout():
    session.pop('user', None)
    session.pop('id', None)
    return redirect(url_for('login'))


@app.route("/home")
def home():
    if 'user' in session:
        conn = sqlite3.connect('database.db')
        conn.row_factory = dict_factory
        c = conn.cursor()
        # Get user, currently set to default id: 1
        userID = session['id']

        c.execute("SELECT * FROM Landlord WHERE landlordID = ?", (userID,))
        landlord = c.fetchone();

        # Get monthly income for user
        c.execute("SELECT SUM(monthlyIncome) as total FROM Property WHERE landlordID = ?", (userID,))
        totalIncome = c.fetchone()

        # Get monthly outcome for user
        c.execute("SELECT * FROM MonthlyExpenses")
        totalOutcome = c.fetchone()

        # Get properties
        c.execute("SELECT * FROM Property WHERE landlordID=?", (userID,))
        propertyList = c.fetchall();

        # Get rental agreements for properties owned by user
        c.execute("SELECT * FROM Rents WHERE propertyID IN (SELECT propertyID FROM Property WHERE landlordID = ?)",
                  (userID,))
        renters = c.fetchall();

        # Get tenants of property with propertyID
        # c.execute("SELECT tenantID, name, monthlyRent FROM (SELECT tenantID, companyName as name, monthlyRent FROM Company WHERE tenantID IN (SELECT tenantID FROM Rents WHERE propertyID =?) UNION SELECT tenantID, (firstName||' '||lastName) as name, monthlyRent FROM Individual WHERE tenantID IN ( SELECT tenantID FROM Rents WHERE propertyID =?))", (propertyID,propertyID, ))
        # tenantList = c.fetchall();

        ##### THIS QUERY SATISFIES THE JOIN REQUIREMENT #####
        c.execute(
            "SELECT propertyID, name, monthlyRent FROM Rents JOIN TenantTemp ON (Rents.tenantID == TenantTemp.tenantID) WHERE propertyID IN (SELECT propertyID FROM Property WHERE landlordID = ?)",
            (userID,))
        tenantList = c.fetchall();

        return render_template('home.html',
                               user=landlord,
                               income=totalIncome,
                               outcome=totalOutcome,
                               properties=propertyList,
                               rentalList=renters,
                               tenants=tenantList
                               )
    else:
        return redirect(url_for('login'))


@app.route("/landlords")
def landlords():
    conn = sqlite3.connect('database.db')
    conn.row_factory = dict_factory
    c = conn.cursor()
    c.execute("SELECT * FROM Landlord")
    landlords = c.fetchall()

    return render_template('landlords.html', data=landlords)


@app.route("/info")
def info():
    if 'user' in session:
        username = session['user']
        conn = sqlite3.connect('database.db')
        conn.row_factory = dict_factory
        c = conn.cursor()
        c.execute("SELECT * FROM Landlord WHERE firstName=='" + username + "'")
        landlords = c.fetchall()
        return render_template('info.html', data=landlords)
    else:
        return redirect(url_for('login'))


@app.route("/properties")
def properties():
    if 'user' in session:
        username = session['user']
        id = session['id']

        conn = sqlite3.connect('database.db')
        conn.row_factory = dict_factory
        c = conn.cursor()
        c.execute("SELECT * FROM Landlord L, Property P WHERE L.landlordID==P.landlordID AND L.landlordID==" + str(id))
        properties = c.fetchall()
        return render_template('properties.html', data=properties)
    else:
        return redirect(url_for('login'))


@app.route("/query")
def query():
    if 'user' in session:
        username = session['user']
        userID = session['id']

        conn = sqlite3.connect('database.db')
        conn.row_factory = dict_factory
        c = conn.cursor()
        # Aggregation query with COUNT function
        c.execute("SELECT COUNT (*) AS totalProperty FROM Property WHERE landlordID=?", (userID,))
        totalProperty = c.fetchall()
        # Sum of property net worth group by province query
        c.execute("SELECT province, SUM(price) AS netWorth FROM Property WHERE landlordID=? GROUP BY province",
                  (userID,))
        netWorth = c.fetchall()

        # Display unchanged property price
        c.execute("SELECT street, price FROM Property WHERE landlordID=?", (userID,))
        unchangedPrice=c.fetchall()
        # Update new price for property price
        c.execute("UPDATE Property SET price=price*1.1 WHERE landlordID=?", (userID,))
        c.execute("SELECT street, price FROM Property WHERE landlordID=?", (userID,))
        newPrice= c.fetchall()
        return render_template('query.html',
                               totalProperty=totalProperty,
                               netWorth=netWorth,
                               unchangedPrice=unchangedPrice,
                               newPrice=newPrice
                               )
    else:
        return redirect(url_for('login'))

@app.route("/insert")
def insert():
    if 'user' in session:
        username = session['user']
        id = session['id']

        conn = sqlite3.connect('database.db')
        conn.row_factory = dict_factory
        c = conn.cursor()
        c.execute("SELECT * FROM Landlord L, Property P WHERE L.landlordID==P.landlordID AND L.landlordID==" + str(id))
        properties = c.fetchall()
        c.execute("INSERT INTO Property (province,street,postcode,price,monthlyIncome,lotSize,buildDate,landlordID) VALUES ('Ontario','4080 Granville St','V5Y3M2','143233.04','4000','5500','2012','1')")
        c.execute("SELECT * FROM Landlord L, Property P WHERE L.landlordID==P.landlordID AND L.landlordID==" + str(id))
        newInsert = c.fetchall()
        return render_template('properties.html', data=properties, newInsert=newInsert)
    else:
        return redirect(url_for('login'))

# @app.route("/register", methods=['GET', 'POST'])
# def register():
#     form = RegistrationForm()

#     if form.validate_on_submit():
#         conn = sqlite3.connect('database.db')
#         c = conn.cursor()

#         #Add the new blog into the 'blogs' table
#         query = 'insert into users VALUES (?, ?, ?)'
#         c.execute(query, (form.username.data, form.email.data, form.password.data)) #Execute the query
#         conn.commit() #Commit the changes

#         flash(f'Account created for {form.username.data}!', 'success')
#         return redirect(url_for('home'))
#     return render_template('register.html', title='Register', form=form)


# @app.route("/blog", methods=['GET', 'POST'])
# def blog():
#     conn = sqlite3.connect('blog.db')

#     #Display all usernames stored in 'users' in the Username field
#     conn.row_factory = lambda cursor, row: row[0]
#     c = conn.cursor()
#     c.execute("SELECT username FROM users")
#     results = c.fetchall()
#     users = [(results.index(item), item) for item in results]

#     form = BlogForm()
#     form.username.choices = users

#     if form.validate_on_submit():
#         choices = form.username.choices
#         user =  (choices[form.username.data][1])
#         title = form.title.data
#         content = form.content.data

#         #Add the new blog into the 'blogs' table in the database
#         query = 'insert into blogs (username, title, content) VALUES (?, ?, ?)' #Build the query
#         c.execute(query, (user, title, content)) #Execute the query
#         conn.commit() #Commit the changes

#         flash(f'Blog created for {user}!', 'success')
#         return redirect(url_for('home'))
#     return render_template('blog.html', title='Blog', form=form)

if __name__ == '__main__':
    app.run(debug=True)
