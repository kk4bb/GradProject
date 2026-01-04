# Notes for me
this was mentioned by llm to start the setup for JWT by adding this to appsettings.json

  "JwtSettings": {
    "Secret": "YOUR_SUPER_SECRET_KEY",
    "Issuer": "LMS",
    "Audience": "LMS",
    "ExpiryMinutes": 60
},


# Building and Running
before anything install postgresql and .net , asp.net .
before doing anything try running `createdb lms` if it works then you should have everything ready to go, if not then you need to setup the database manually till we figure out a way to host the database on a cloud platfrom or something.
if it didn't work then you create a postgresql user called lms_user by typing psql which lets you enter a shell where you can do postgresql things then run these

```
CREATE USER lms_user WITH PASSWORD 'Secure_Password@123';
CREATE DATABASE lms OWNER lms_user;
\c lms
GRANT USAGE ON SCHEMA public TO lms_user;
GRANT CREATE ON SCHEMA public TO lms_user;

GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO lms_user;

GRANT USAGE, SELECT, UPDATE ON ALL SEQUENCES IN SCHEMA public TO lms_user;

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO lms_user;

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT USAGE, SELECT, UPDATE ON SEQUENCES TO lms_user;

ALTER DEFAULT PRIVILEGES FOR ROLE kab IN SCHEMA public GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO lms_user;

ALTER DEFAULT PRIVILEGES FOR ROLE kab IN SCHEMA public GRANT USAGE, SELECT, UPDATE ON SEQUENCES TO lms_user;

INSERT INTO "Users" ("Email", "PasswordHash", "FullName") VALUES ('test@example.com', 'hash123', 'Test User');
```

now you should have it all ready to go
go into the api folder and run:
```dotnet build && dotnet run```


then you'll can go to the localhost with whatever port you have that's listed in the command output and type /api/users after it, example: "http://localhost:5101/api/users" 
(we only have one dummy user for now)

this is only the database linking but in no way an actual api or a full database

# Masoud
- why did you use x meaning we need to be able to explain every choice we made (ex: flutter cross platfrom vs optimization)
- identity services, having one may be challenging to make it secure (identity service to make sure if the person signing up is a normal user or staff, there is no right answer but we should reconsider)
- Testing
    - unit
    - integration
    - end to end
    - *prentesting*
    - *performance*

- look into making a survey asking the doctors about and TAs what feature would they like
- don't have a single point of failure + have a disaster recovery plan
- reconsider the student services center and in-app messaging features (seems useless)

# ERD notes
- Is the enrollment entity connecting both the user and course entity or is the user entity connected directly to both of them

# Miscellaneous

