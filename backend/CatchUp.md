# Why?

This is for anyone who makes some bug changes to explain/document them here (code should have comments explaining it though)

# What remains
- Attendance feature with qr codes
- AI chatbot
- teaching staff side of things
- THOROUGH TESTING OF EVERYTHING


## The Big Start
Mo started with the project and created the authentication so I'm writing all of this to make it easier for everyone else to setup everything and get started.
You need:
- dotnet 8.0
- mssql-server (Microsoft Sql server and tools)
- entity framework

you can install **dotnet 8.0** by going to the [official Microsoft website](https://dotnet.microsoft.com/en-us/download/dotnet/8.0) and downloading the sdk and asp.net just in case (I don't use windows so I genuinly don't know)


For **microsoft sql server** you can paste this [link](https://go.microsoft.com/fwlink/?linkid=2344626&clcid=0x409&culture=en-us&country=us) directly into a browser and then install ssms if you want a gui from [here](https://learn.microsoft.com/en-us/ssms/install/install) and should be easy to navigate from there

When looking at the authentication mode MAKE SURE IT'S SET TO MIXED and make the default password for the database same as the one in api/appsettings.json so that you don't need to modify it everytime (or if yall want a different default password sure)
If you already have everything setup then you can change it
- Right-click the Server (top of the tree) -> Properties -> Security.
- Select SQL Server and Windows Authentication mode.
- Go to Security -> Logins.
- Right-click sa -> Properties.
- Set the password to ACDC_Goated@135.
- Go to the Status page and ensure "Login" is set to Enabled.
- Open "Services" in Windows, find SQL Server (MSSQLSERVER) or SQL Server (SQLEXPRESS), and click Restart.


For the **entity framework** you should be able to run ```dotnet tool install --global dotnet-ef``` inside a terminal and no problem


---

Now that you have everything setup try running, there are still some steps to go through:
- Change the values for the DefaultConnection inside api/appsettings.json if you're using something different
- Setup the database by running ```dotnet ef database update --project infrastructure --startup-project api```


Finally, try running ```dotnet build && dotnet run``` inside the api folder and you should see something similar to this line

```
~/hdd/Learn/Code/GradProject/backend main +141 !2 ?15 ❯ dotnet run
Using launch settings from ./api/Properties/launchSettings.json...
Building...
info: Microsoft.Hosting.Lifetime[14]
      Now listening on: http://localhost:5205
info: Microsoft.Hosting.Lifetime[0]
      Application started. Press Ctrl+C to shut down.
info: Microsoft.Hosting.Lifetime[0]
      Hosting environment: Development
info: Microsoft.Hosting.Lifetime[0]
      Content root path: /run/media/kab/hdd/Learn/Code/GradProject/backend/api
```

If yes then you're a lucky one because it worked with no hiccups (I hope lmao)


# Notes for testing
## Credentials
**Instructor**
dr.smith@campusconnect.edu   Password123!

**Student**
john.doe@example.com   Password123!

## Commands
to avoid issue with the copying and pasting the jwt token you can use httpie and jq with this command
http GET localhost:5205/api/student/me "Authorization: Bearer $(http --ignore-stdin POST localhost:5205/api/auth/login email=john.doe@example.com password='Password123!' | jq -r .token)"

# Gathering required features
## Student View
### Profile page
the profile section for teaching staff has
- name
- Faculty
- ID
- academic year
- credit hours

ignoring
- the rank thing


to publish the backend so that it can be transferred to the remote server run
```
dotnet publish -c Release -r linux-arm64 --self-contained true
```
