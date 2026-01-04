# Components of an api

## Controllers
The doorman for all api calls going in or out
They don't have anything relating to business logic but they: accept requests => validate inputs => forward them to the appropriate services => return the service's response

## Services
If controllers are the doormen, services are the workers
Services are responsible for the business logic for the whole application like fetching users, generating tokens, etc...

## Models
### DTO (Data Transfer Objects)
These are the main way to send and encapsulate data send between different systems within the app (especially services and the UI)

### Database Model (Entities)
They represent the database tables and if we're using linq then they can be the tables not just a representation

## Data Layer
This layer defines how the database interacts with services 


