FORMAT: 1A
HOST: http://beautboss-staging.elasticbeanstalk.com/api/v1

# BeautBoss

API documentation for **BeautBoss** app.

## Users [/users]

### Create a New User [POST]

Create user with specifed user params. Returns saved user and authorization token.

+ Parameters

    + name (string) - User's personal name.
    + email (string) - User's email used for login.
    + password (string) - User's password used for login.

+ Request

+ Response 201 (application/json)

    + Headers

            Location: /users/{id}

    + Body

        {
            "user": {
              "id": 1,
              "name": "Test",
              "email": "test@example.com",
              "website": null,
              "location": null,
              "bio": null,
              "created_at": "2015-09-21T03:02:16.444Z"
            },
            "token": "e9f3b305-0eda-482d-8d7d-6dde16d8c0d7"
        }        
            
### Get an User [GET /users/{id}]

+ Parameters

    + id (number) - User's unique identifier.

+ Response 200 (application/json)

    + Headers

            Location: /users/{id}

    + Body
    
            {
              "id": 1,
              "name": "Test",
              "email": "test@example.com",
              "website": null,
              "location": null,
              "bio": null,
              "created_at": "2015-09-21T03:02:16.444Z"
            }
            
### Update an User [PUT /users/{id}]

+ Request (application/json)

    + Headers
    
        TOKEN: {authentication}
        
    + Body

        {
            "id": 1,
            "name": "Test",
            "email": "test@example.com",
            "website": "example.com",
            "location": "São Paulo, Brazil",
            "bio": "testing the app like a boss.",
            "created_at": "2015-09-21T03:02:16.444Z"
        }
    
+ Response 200 (application/json)

    + Headers

            Location: /users/{id}

    + Body
    
        {
            "id": 1,
            "name": "Test",
            "email": "test@example.com",
            "website": "example.com",
            "location": "São Paulo, Brazil",
            "bio": "testing the app like a boss.",
            "created_at": "2015-09-21T03:02:16.444Z"
        }

## Authentication [/authentications]

### Create Authorization Token [POST]

### Create Token from Facebook [POST /authorizations/facebook]

### Request Password Reset [POST /authorizations/password_reset]

## Places [/places]

### List Places [GET]

+ Parameters

    + lat (number) - Latitude in the format **XX.XX**
    + lon (number) - Longitude in the format **YY.YY**
    + query (string) - Search query for Foursquare venues, like venue name i.e. "starbucks", or venue type i.e. "coffee shop".
    
+ Request (application/json)

    + Headers
    
        TOKEN: {authentication}

+ Response 200 (application/json)

    + Headers

            Location: /places

    + Body
    
        [
          {
            "id": null,
            "foursquare_id": "4fcbc5e4e4b0e33fd50528a6",
            "name": "Haircut",
            "lat": "-23.638725",
            "lon": "-46.516178",
            "address": "[\"Rua Suíça 1212 (Rua Do Oratorio)\", \"Santo André, SP\", \"09210-000\", \"Brasil\"]",
            "contact": null,
            "website": null
          },
          {
            "id": 1,
            "foursquare_id": "4fb18581e4b0d327d5bd0395",
            "name": "Hair Cut",
            "lat": "-23.57415824383387",
            "lon": "-46.64817670579847",
            "address": "[\"Rua Mario Amaral (Rua Rafael de Barros)\", \"São Paulo, SP\", \"Brasil\"]",
            "contact": "+551130612628",
            "website": null
          }
        ]

### Create a New Place [POST]

+ Request (application/json)

    + Headers
    
        TOKEN: {authentication}
        
    + Body

        {
            "foursquare_id": "0000000x000x000xx000x00x",
            "name": "Example Haircut",
            "lat": "-23.99440171762515",
            "lon": "-46.15780148090618",
            "address": "SP, Brasil",
            "contact": "+551155555555"
        }
        
+ Response 201 (application/json)

    + Headers

            Location: /places/{id}

    + Body
    
        {
            "id": 1,
            "foursquare_id": "0000000x000x000xx000x00x",
            "name": "Example Haircut",
            "lat": "-23.99440171762515",
            "lon": "-46.15780148090618",
            "address": "SP, Brasil",
            "contact": "+551155555555"
        }

### Get Place info  [GET /places/{id}]

+ Parameters

    + id (number) - Place's unique identifier.

+ Response 200 (application/json)

    + Headers

            Location: /places/{id}

    + Body
    
            {
                "id": 1,
                "foursquare_id": "0000000x000x000xx000x00x",
                "name": "Example Haircut",
                "lat": "-23.99440171762515",
                "lon": "-46.15780148090618",
                "address": "SP, Brasil",
                "contact": "+551155555555"
            }

## Posts [/posts]

### Create a New Post [POST]

+ Request (application/json)

    + Headers
    
            TOKEN: {authentication}
        
    + Body

            {
                "caption": "Post example",
                "image": "elasticbeanstalk-us-west-2-868619448283/BeautBoss/registers/somepost.png",
                "place_id": 1
            }
        
+ Response 201 (application/json)

    + Headers

            Location: /posts/{id}

    + Body
    
            {
              "id": 1,
              "caption": "Post example",
              "image": "elasticbeanstalk-us-west-2-868619448283/BeautBoss/registers/somepost.png",
              "user": {
                "id": 2,
                "name": "John Doe",
                "email": "john@example.com",
                "created_at": "2015-09-09T14:27:13.000Z"
              },
              "place": {
                "id": 1,
                "name": "Janete Haircutter Lima",
                "created_at": "2015-09-22T20:26:42.000Z",
                "lat": "-23.60309168741059",
                "lon": "-46.52768366628087",
                "address": "[\"Brasil\"]",
                "foursquare_id": "550427a0498e1e919131fb65",
                "contact": null,
                "website": null
              },
              "category": null,
              "service": null
            }

## Wows [/posts/{post_id}/wows]

+ Parameters
    + post_id (number) - The ID of the Post.

### Wow a Post [POST]

+ Request

    + Headers
    
            TOKEN: {authentication}

+ Response 200

### Get all Wows from a Post [GET]

+ Request

    + Headers
    
            TOKEN: {authentication}
            
+ Response 200 (application/json)

    + Headers

            Location: /posts/{post_id}

    + Body
    
            [
              {
                "id": 1,
                "created_at": "2015-09-23T00:41:37.000Z",
                "user": {
                  "id": 2,
                  "name": "John Doe",
                  "email": "john@example.com",
                  "website": null,
                  "location": null,
                  "bio": null,
                  "created_at": "2015-09-13T20:25:45.000Z"
                }
              },
              {
                "id": 2,
                "created_at": "2015-09-23T00:42:39.000Z",
                "user": {
                  "id": 1,
                  "name": "Jane Smith",
                  "email": "jane@example.com",
                  "website": null,
                  "location": null,
                  "bio": null,
                  "created_at": "2015-09-23T00:42:27.000Z"
                }
              }
            ]
            




### De-wow a Post [DELETE]

+ Request

    + Headers
    
            TOKEN: {authentication}
            
+ Response 200

## Follows [/users/{user_id}/follow]

+ Parameters
    + user_id (number) - The ID of the User.

### Follow an User [POST]

+ Request

    + Headers
    
            TOKEN: {authentication}

+ Response 201

### Unfollow an User [DELETE]

+ Request

    + Headers
    
            TOKEN: {authentication}
            
+ Response 204

## Followers [/users/{user_id}/followers]

+ Parameters
    + user_id (number) - The ID of the User.

+ Request

    + Headers
    
            TOKEN: {authentication}

+ Response 200 (application/json)

## Following [/users/{user_id}/following]

+ Parameters
    + user_id (number) - The ID of the User.

+ Request

    + Headers
    
            TOKEN: {authentication}

+ Response 200 (application/json)
