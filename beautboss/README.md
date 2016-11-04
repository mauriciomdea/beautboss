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
              "username": "test",
              "email": "test@example.com",
              "avatar": "somecdn.com/images/user.png",
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
              "username": "test",
              "email": "test@example.com",
              "avatar": "somecdn.com/images/user.png",
              "website": null,
              "location": null,
              "bio": null,
              "followers": 0,
              "following": 0,
              "posts": 0,
              "is_following": false,
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
            "username": "test",
            "email": "test@example.com",
            "avatar": "somecdn.com/images/user.png",
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
            "username": "test",
            "email": "test@example.com",
            "avatar": "somecdn.com/images/user.png",
            "website": "example.com",
            "location": "São Paulo, Brazil",
            "bio": "testing the app like a boss.",
            "created_at": "2015-09-21T03:02:16.444Z"
        }

## Authentication [/authentications]

### Create Authorization Token [POST]

+ Parameters

    + email (string) - User's email address.
    + password (string) - User's password.

+ Request (application/json)

    + Headers

+ Response 201 (application/json)

    + Headers

            Location: /users/{id}

    + Body

        {
            "user": {
              "id": 1,
              "name": "Test",
              "username": "test",
              "email": "test@example.com",
              "avatar": "somecdn.com/images/user.png",
              "website": null,
              "location": null,
              "bio": null,
              "created_at": "2015-09-21T03:02:16.444Z"
            },
            "token": "f3f3b305-0eda-482d-8d7d-6dde16d8d7c0"
        }
        
### Create Token from Facebook [POST /authentications/facebook]

+ Parameters

    + access_token (string) - Facebook's access token.

+ Request (application/json)

    + Headers

+ Response 201 (application/json)

    + Headers

            Location: /users/{id}

    + Body

        {
            "user": {
              "id": 1,
              "name": "Test",
              "username": "test",
              "email": "test@example.com",
              "avatar": "somecdn.com/images/user.png",
              "website": null,
              "location": null,
              "bio": null,
              "created_at": "2015-09-21T03:02:16.444Z"
            },
            "token": "f3f3b305-0eda-482d-8d7d-6dde16d8d7c0"
        }
        
### Request Password Reset [POST /authentications/password_reset]

+ Parameters

    + email (string) - User's email used for login.
    
+ Request (application/json)

    + Headers

+ Response 200 (application/json)

    + Headers

            Location: /authentications/password_reset

    + Body
    
            "Ok"

## Places [/places]

### Search Places [GET]

+ Parameters

    + latitude (number) - Latitude in the format **XX.XX**
    + longitude (number) - Longitude in the format **YY.YY**
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
            "latitude": "-23.638725",
            "longitude": "-46.516178",
            "address": "[\"Rua Suíça 1212 (Rua Do Oratorio)\", \"Santo André, SP\", \"09210-000\", \"Brasil\"]",
            "contact": null,
            "website": null
          },
          {
            "id": null,
            "foursquare_id": "4fb18581e4b0d327d5bd0395",
            "name": "Hair Cut",
            "latitude": "-23.57415824383387",
            "longitude": "-46.64817670579847",
            "address": "[\"Rua Mario Amaral (Rua Rafael de Barros)\", \"São Paulo, SP\", \"Brasil\"]",
            "contact": "+551130612628",
            "website": null
          }
        ]

### Get Place info  [GET /places/{id}]

+ Parameters

    + id (number) - Place's unique identifier.

+ Response 200 (application/json)

    + Headers

            Location: /places/{id}

    + Body
    
            {
                "foursquare_id": "0000000x000x000xx000x00x",
                "name": "Example Haircut",
                "latitude": "-23.99440171762515",
                "longitude": "-46.15780148090618",
                "address": "SP, Brasil",
                "contact": "+551155555555"
            }

## Posts [/posts]

### Create a New Post [POST]

+ Parameters

    + category (string) - Categoria, relativo a uma das seguintes categorias: ["haircut", "hairstyle", "colouring", "highlights", "nails", "makeup"].
    + service (string) - Title of the register.
    + image (string) - URL to the posted image.
    + latitude (string) - Latitude  do usuário XX.XX.
    + longitude (string) - Longitude  do usuário YY.YY.
    + foursquare_id (number, optional) - Place's unique identifier.
    + caption (string, optional) - Add post with a personal comment.

+ Request (application/json)

    + Headers
    
            TOKEN: {authentication}
        
+ Response 201 (application/json)

    + Headers

            Location: /posts/{id}

    + Body
    
            {
              "id": 1,
              "category": "haircut",
              "latitude": 0.01,
              "longitude": 0.01,
              "service": "Post example",
              "image": "elasticbeanstalk-us-west-2-868619448283/BeautBoss/registers/somepost.png",
              "comments": 0,
              "wows": 0,
              "user": {
                "id": 1
                "name": "John Doe"
                "avatar": "https://scontent.xx.fbcdn.net/hprofile-xtp1/v/t1.0-1/p50x50/12038035_10153568053793444_3955325592428203406_n.jpg"
              },
              "place": {
                "foursquare_id": "550427a0498e1e919131fb65",
                "name": "Janete Haircutter Lima",
                "created_at": "2015-09-22T20:26:42.000Z",
                "latitude": "-23.60309168741059",
                "longitude": "-46.52768366628087",
                "address": "[\"Brasil\"]",
                "contact": null,
                "website": null
              }
            }

### Get Post [GET /posts/{post_id}]

+ Parameters

    + post_id (number) - The ID of the Post.
    
+ Request (application/json)

    + Headers
    
            TOKEN: {authentication}
            
+ Response 200 (application/json)

    + Headers

            Location: /posts/{id}

    + Body
    
            {
              "id": 1,
              "category": "haircut",
              "latitude": 0.01,
              "longitude": 0.01,
              "service": "Post example",
              "image": "elasticbeanstalk-us-west-2-868619448283/BeautBoss/registers/somepost.png",
              "comments": 0,
              "wows": 0,
              "user": {
                "id": 1
                "name": "John Doe"
                "avatar": "https://scontent.xx.fbcdn.net/hprofile-xtp1/v/t1.0-1/p50x50/12038035_10153568053793444_3955325592428203406_n.jpg"
              },
              "place": {
                "name": "Janete Haircutter Lima",
                "created_at": "2015-09-22T20:26:42.000Z",
                "lat": "-23.60309168741059",
                "lon": "-46.52768366628087",
                "address": "[\"Brasil\"]",
                "foursquare_id": "550427a0498e1e919131fb65",
                "contact": null,
                "website": null
              }
            }

### Flag a Post [POST /posts/{post_id}/reports]

+ Parameters

    + post_id (number) - The ID of the Post.
    + flag (string) - Flag type: ["innapropriate", "wrong_location", "closed_or_private", "copyright_infringement", "other"].
    + explanation (string) - Self-explanatory.
    
+ Request (application/json)

    + Headers
    
            TOKEN: {authentication}
            
+ Response 201 (application/json)


### Search all posts [GET /posts]

+ Parameters

    + category (string) - Categoria, relativo a uma das seguintes categorias: ["haircut": 0,"hairstyle": 1, "colouring": 2, "highlights": 3, "nails": 4, "makeup": 5].
    + latitude (string) - Latitude  do usuário XX.XX.
    + longitude (string) - Longitude  do usuário YY.YY.
    + have_place (boolean, optional) - filtro para tipo de local (todos/publico/privado = null/true/false).
        + Default: null
    <!--+ query (string, optional) - Filtro para o nome do serviço/título.-->
    + service (string, optional) - Filtro para o nome do serviço/título.
    + order (string, optional) - Tipo de ordenação do busca. Vamos definir eles fixos, mas inicialmente devemos ter: ["latest", "best", "closest"]
        + Default: "latest"
    + limit (number, optional) - Maximum number of records to be retrieved.
        + Default: `20`
    + offset (number, optional) - Number of records to skip before starting to return the records.
        + Default: `0`

+ Request (application/json)

    + Headers
    
            TOKEN: {authentication}

+ Response 200 (application/json)

    + Headers

            Location: /posts

    + Body
    
            [
                {
                    "id": 1,
                    "category": "haircut",
                    "latitude": -23.1234,
                    "longitude": -46.1234,
                    "service": "Female Haircut",
                    "user": {
                        "id": 2
                        "name": "Jane Smith"
                        "avatar": "https://scontent.xx.fbcdn.net/hprofile-xtp1/v/t1.0-1/p50x50/12038035_10153568053793444_3955325592428203406_n.jpg"
                    },
                    "place": {
                        "id": 123,
                        "name": "Beau London",
                        "lat": -23.1234,
                        "lon": -46.1234
                    },
                    <!--"wow": 26,-->
                    <!--"wow_friends": 6,-->
                    <!--"my_wow": false,-->
                    "url": "http://symphony.clinic/wp-content/uploads/2015/05/haircut.jpg",
                    "created_at": "2015-10-10T16:43:10.000Z"
                },
                {
                    "id": 2,
                    "category": "haircut",
                    "latitude": -23.1234,
                    "longitude": -46.1234,
                    "service": "Male Haircut",
                    "user": {
                        "id": 1
                        "name": "John Doe"
                        "avatar": "https://scontent.xx.fbcdn.net/hprofile-xtp1/v/t1.0-1/p50x50/12038035_10153568053793444_3955325592428203406_n.jpg"
                    },
                    "place": null,
                    <!--"wow": 4-->
                    <!--"wow_friends": 0,-->
                    <!--"my_wow": true,-->
                    "url": "http://frisurenfriseur.com/wp-content/uploads/2015/07/lange-bob-frisuren-asymmetrical-short-bob-haircut.jpg",
                    "created_at": "2015-10-10T16:43:10.000Z"
                }
            ]



### Get all posts from an User [GET /users/{user_id}/posts]

+ Parameters

    + user_id (number) - The ID of the User.
    
+ Request (application/json)

    + Headers
    
            TOKEN: {authentication}
            
+ Response 200 (application/json)

    + Headers

            Location: /users/{user_id}/posts

    + Body
    
            [
                {
                  "id": 1,
                  "category": "haircut",
                  "latitude": -23.1234,
                  "longitude": -46.1234,
                  "service": "Female Haircut",
                  "image": "elasticbeanstalk-us-west-2-868619448283/BeautBoss/registers/somepost.png",
                  "comments": 0,
                  "wows": 0,
                  "user": {
                    "id": 1,
                    "name": "Jane Smith",
                    "avatar": "https://scontent.xx.fbcdn.net/hprofile-xtp1/v/t1.0-1/p50x50/12038035_10153568053793444_3955325592428203406_n.jpg"
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
                  "created_at": "2015-10-10T16:43:10.000Z"
                },
                {
                  "id": 2,
                  "category": "haircut",
                  "latitude": -23.1234,
                  "longitude": -46.1234,
                  "service": "Male Haircut",
                  "image": "elasticbeanstalk-us-west-2-868619448283/BeautBoss/registers/somepost.png",
                  "user": {
                    "id": 2,
                    "name": "John Doe",
                    "avatar": "https://scontent.xx.fbcdn.net/hprofile-xtp1/v/t1.0-1/p50x50/12038035_10153568053793444_3955325592428203406_n.jpg"
                  },
                  "place": {
                    "id": 2,
                    "name": "Belo Hair",
                    "created_at": "2015-09-22T20:26:42.000Z",
                    "lat": "-32.60309168745910",
                    "lon": "-64.52768366628780",
                    "address": "[\"Brasil\"]",
                    "foursquare_id": "990427a0498e1e919131fb65",
                    "contact": null,
                    "website": null
                  },
                  "created_at": "2015-10-10T16:43:10.000Z"
                }
            ]

### Get all posts from a Place [GET /places/{place_id}/posts]

+ Parameters

    + place_id (number) - The ID of the Place.
    
+ Request (application/json)

    + Headers
    
            TOKEN: {authentication}
            
+ Response 200 (application/json)

    + Headers

            Location: /places/{place_id}/posts

    + Body
    
            [
                {
                  "id": 1,
                  "category": "haircut",
                  "latitude": -23.1234,
                  "longitude": -46.1234,
                  "service": "Male Haircut",
                  "image": "elasticbeanstalk-us-west-2-868619448283/BeautBoss/registers/somepost.png",
                  "comments": 0,
                  "wows": 0,
                  "user": {
                    "id": 2,
                    "name": "John Doe",
                    "avatar": "https://scontent.xx.fbcdn.net/hprofile-xtp1/v/t1.0-1/p50x50/12038035_10153568053793444_3955325592428203406_n.jpg"
                  },
                  "place": {
                    "id": 1,
                    "name": "Janete Haircutter Lima",
                    "created_at": "2015-09-22T20:26:42.000Z",
                    "latitude": "-23.60309168741059",
                    "longitude": "-46.52768366628087",
                    "address": "[\"Brasil\"]",
                    "foursquare_id": "550427a0498e1e919131fb65",
                    "contact": null,
                    "website": null
                  }
                },
                {
                  "id": 2,
                  "category": "haircut",
                  "latitude": -23.1234,
                  "longitude": -46.1234,
                  "service": "Female Haircut",
                  "image": "elasticbeanstalk-us-west-2-868619448283/BeautBoss/registers/somepost.png",
                  "comments": 0,
                  "wows": 0,
                  "user": {
                    "id": 1,
                    "name": "Jane Smith",
                    "avatar": "https://scontent.xx.fbcdn.net/hprofile-xtp1/v/t1.0-1/p50x50/12038035_10153568053793444_3955325592428203406_n.jpg"
                  },
                  "place": {
                    "id": 1,
                    "name": "Janete Haircutter Lima",
                    "created_at": "2015-09-22T20:26:42.000Z",
                    "latitude": "-23.60309168741059",
                    "longitude": "-46.52768366628087",
                    "address": "[\"Brasil\"]",
                    "foursquare_id": "550427a0498e1e919131fb65",
                    "contact": null,
                    "website": null
                  }
                }
            ]

## Comments [/posts/{post_id}/comments]

+ Parameters

    + post_id (number) - The ID of the Post.

### Comment a Post [POST]

+ Parameters

    + comment (string) - The comment.
    
+ Request

    + Headers
    
            TOKEN: {authentication}

+ Response 201

### Get all Comments from a Post [GET]

+ Request

    + Headers
    
            TOKEN: {authentication}
            
+ Response 200 (application/json)

    + Headers

            Location: /posts/{post_id}

    + Body
    
            {
                "count": 2,
                "comments": [
                    {
                      "id": 3,
                      "comment": "nice register!",
                      "created_at": "2015-10-12T19:14:46.000Z",
                      "user": {
                        "id": 2,
                        "name": "Test",
                        "avatar": null
                      }
                    },
                    {
                      "id": 4,
                      "comment": "Thank you!",
                      "created_at": "2015-10-12T19:15:09.000Z",
                      "user": {
                        "id": 11,
                        "name": "Mauricio Almeida",
                        "avatar": "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xtp1/v/t1.0-1/p50x50/12038035_10153568053793444_3955325592428203406_n.jpg?oh=866157dbf59eb64cb6c746b2acfdc180&oe=56D3406B&__gda__=1451766951_76d4338e8ace5eda1d0eced5aec853f2"
                      }
                    }
                ]
            }
            
### Delete a Comment [DELETE /posts/{post_id}/comments/{comment_id}]

+ Request

    + Headers
    
            TOKEN: {authentication}
            
+ Response 204


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
            
+ Response 204


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

### Followers [GET /users/{user_id}/followers]

+ Parameters

    + user_id (number) - The ID of the User.
    + limit (number, optional) - Maximum number of records to be retrieved.
        + Default: `20`
    + offset (number, optional) - Number of records to skip before starting to return the records.
        + Default: `0`

+ Request

    + Headers
    
            TOKEN: {authentication}

+ Response 200 (application/json)

    + Headers

            Location: /users/{user_id}/followers

    + Body
    

### Following [GET /users/{user_id}/following]

+ Parameters

    + user_id (number) - The ID of the User.
    + limit (number, optional) - Maximum number of records to be retrieved.
        + Default: `20`
    + offset (number, optional) - Number of records to skip before starting to return the records.
        + Default: `0`

+ Request

    + Headers
    
            TOKEN: {authentication}

+ Response 200 (application/json)

    + Headers

            Location: /users/{user_id}/following

    + Body
    
## Blocking [/users/{user_id}/block]

+ Parameters

    + user_id (number) - The ID of the User.

### Block an User [POST]

+ Request

    + Headers
    
            TOKEN: {authentication}

+ Response 201

### Unblock an User [DELETE]

+ Request

    + Headers
    
            TOKEN: {authentication}
            
+ Response 204

### Blocked users [GET /users/{user_id}/blocked]

+ Parameters

    + user_id (number) - The ID of the User.
    + limit (number, optional) - Maximum number of records to be retrieved.
        + Default: `20`
    + offset (number, optional) - Number of records to skip before starting to return the records.
        + Default: `0`

+ Request

    + Headers
    
            TOKEN: {authentication}

+ Response 200 (application/json)

    + Headers

            Location: /users/{user_id}/blocked

    + Body


## Friends [/users/{user_id}/friends]

### Find Facebook friends [GET]

+ Parameters

    + access_token (string) - Facebook's access token.

+ Request

+ Response 200 (application/json)

    + Headers

            Location: /users/{user_id}/friends

    + Body

        {
            "count": 1,
            "users": [
                {
                  "id": 1,
                  "name": "Test",
                  "username": "test",
                  "facebook": "01010101010",
                  "email": "test@example.com",
                  "avatar": "somecdn.com/images/user.png",
                  "website": null,
                  "location": null,
                  "bio": null,
                  "is_following": false,
                  "created_at": "2015-09-21T03:02:16.444Z"
                }
            ]
        }
        
### Find friends from contacts [GET]

+ Parameters

    + emails (string) - List of emails separated by comma: "email1@mail.com, email2@mail.com".

+ Request

+ Response 200 (application/json)

    + Headers

            Location: /users/{user_id}/friends

    + Body

        {
            "count": 1,
            "users": [
                {
                  "id": 1,
                  "name": "Test",
                  "username": "test",
                  "facebook": "01010101010",
                  "email": "test@example.com",
                  "avatar": "somecdn.com/images/user.png",
                  "website": null,
                  "location": null,
                  "bio": null,
                  "is_following": false,
                  "created_at": "2015-09-21T03:02:16.444Z"
                }
            ]
        }


## Newsfeed [/newsfeed]

+ Parameters
    
    + limit (number, optional) - Maximum number of records to be retrieved.
        + Default: `20`
    + offset (number, optional) - Number of records to skip before starting to return the records.
        + Default: `0`

### Newsfeed [GET]

+ Request

    + Headers
    
            TOKEN: {authentication}

+ Response 200 (application/json)

    + Headers

            Location: /newsfeed

    + Body

            [
                {
                  "id": 1,
                  "category": "haircut",
                  "latitude": -23.1234,
                  "longitude": -46.1234,
                  "service": "Male Haircut",
                  "image": "elasticbeanstalk-us-west-2-868619448283/BeautBoss/registers/somepost.png",
                  "comments": 0,
                  "wows": 0,
                  "user": {
                    "id": 2,
                    "name": "John Doe",
                    "avatar": "https://scontent.xx.fbcdn.net/hprofile-xtp1/v/t1.0-1/p50x50/12038035_10153568053793444_3955325592428203406_n.jpg"
                  },
                  "place": {
                    "id": 1,
                    "name": "Janete Haircutter Lima",
                    "created_at": "2015-09-22T20:26:42.000Z",
                    "latitude": "-23.60309168741059",
                    "longitude": "-46.52768366628087",
                    "address": "[\"Brasil\"]",
                    "foursquare_id": "550427a0498e1e919131fb65",
                    "contact": null,
                    "website": null
                  }
                },
                {
                  "id": 2,
                  "category": "haircut",
                  "latitude": -23.1234,
                  "longitude": -46.1234,
                  "service": "Female Haircut",
                  "image": "elasticbeanstalk-us-west-2-868619448283/BeautBoss/registers/somepost.png",
                  "comments": 0,
                  "wows": 0,
                  "user": {
                    "id": 1,
                    "name": "Jane Smith",
                    "avatar": "https://scontent.xx.fbcdn.net/hprofile-xtp1/v/t1.0-1/p50x50/12038035_10153568053793444_3955325592428203406_n.jpg"
                  },
                  "place": null
                }
            ]
 
## Notifications [/users/{user_id}/notifications]

+ Parameters
    
    + user_id (number) - The ID of the User.
    + limit (number, optional) - Maximum number of records to be retrieved.
        + Default: `20`
    + offset (number, optional) - Number of records to skip before starting to return the records.
        + Default: `0`

### Notifications [GET]

+ Request

    + Headers
    
            TOKEN: {authentication}

+ Response 200 (application/json)

    + Headers

            Location: /users/{user_id}/notifications

    + Body

            [
                {
                    "created_at": "2015-09-28T23:01:03.000Z",
                    "subject": "comment",
                    "url": "/api/v1/posts/42/comments",
                    "message": "This is just an example comment, please ignore.",
                    "read": false,
                    "actor": {
                        "id": 134
                        "name": "A Follower"
                        "email": "robot2@example.com"
                        "avatar": null
                    }
                },
                {
                    "created_at": "2015-09-28T22:59:03.000Z",
                    "subject": "wow",
                    "url": "/api/v1/posts/42/wows",
                    "message": null,
                    "read": false,
                    "actor": {
                        "id": 131
                        "name": "The Follower"
                        "email": "robot3@example.com"
                        "avatar": null
                    }
                }
            ]
 
## Messages [/users/{user_id}/messages]

### List unread Messages [GET]

+ Parameters
    
    + limit (number, optional) - Maximum number of records to be retrieved.
        + Default: `20`
    + offset (number, optional) - Number of records to skip before starting to return the records.
        + Default: `0`

+ Request

    + Headers
    
            TOKEN: {authentication}

+ Response 200 (application/json)

    + Headers

            Location: /users/{user_id}/messages

    + Body

            [
                {
                  "id": 1,
                  "message": "Hello World!",
                  "read": false,
                  "created_at": "2016-11-04T17:08:09.000Z",
                  "user": {
                    "id": 1,
                    "name": "Rogerio Shimizu",
                    "username": "roja",
                    "avatar": "somecdn.com/images/user.png",
                    "location": "São Paulo, Brazil"
                  },
                  "sender": {
                    "id": 2,
                    "name": "John Doe",
                    "username": "john",
                    "avatar": "somecdn.com/images/user.png",
                    "location": "São Paulo, Brazil"
                  }
                },
                {
                  "id": 2,
                  "message": "Hi World!",
                  "read": false,
                  "created_at": "2016-11-04T17:08:09.000Z",
                  "user": {
                    "id": 1,
                    "name": "Rogerio Shimizu",
                    "username": "roja",
                    "avatar": "somecdn.com/images/user.png",
                    "location": "São Paulo, Brazil"
                  },
                  "sender": {
                    "id": 3,
                    "name": "Jane Smith",
                    "username": "jane",
                    "avatar": "somecdn.com/images/user.png",
                    "location": "São Paulo, Brazil"
                  }
                }
            ]

### Post a new Message [POST]

+ Parameters

    + user_id (number) - The ID of the User who will receive the message.
    + message (string) - The message.
    
+ Request

    + Headers
    
            TOKEN: {authentication}

+ Response 201 (application/json)

    + Headers

            Location: /users/{user_id}/messages/{message_id}

    + Body

            {
              "id": 1,
              "message": "Hello World!",
              "read": false,
              "created_at": "2016-11-04T17:08:09.000Z",
              "user": {
                "id": 1,
                "name": "Rogerio Shimizu",
                "username": "roja",
                "avatar": "somecdn.com/images/user.png",
                "location": "São Paulo, Brazil"
              },
              "sender": {
                "id": 3,
                "name": "Jane Smith",
                "username": "jane",
                "avatar": "somecdn.com/images/user.png",
                "location": "São Paulo, Brazil"
              }
            }

### Get a Message [GET /users/{user_id}/messages/{message_id}]

+ Parameters 

    + user_id (number) - The ID of the User who received the message.
    + message_id (number) - The ID of the Message.

+ Request

    + Headers
    
            TOKEN: {authentication}

+ Response 200

    + Body

            {
              "id": 1,
              "message": "Hello World!",
              "read": false,
              "created_at": "2016-11-04T17:08:09.000Z",
              "user": {
                "id": 1,
                "name": "Rogerio Shimizu",
                "username": "roja",
                "avatar": "somecdn.com/images/user.png",
                "location": "São Paulo, Brazil"
              },
              "sender": {
                "id": 3,
                "name": "Jane Smith",
                "username": "jane",
                "avatar": "somecdn.com/images/user.png",
                "location": "São Paulo, Brazil"
              }
            }

### Delete a Message [DELETE /users/{user_id}/messages/{message_id}]

+ Parameters 

    + user_id (number) - The ID of the User who received the message. Can only delete messages sent to the current logged user.
    + message_id (number) - The ID of the Message.

+ Request

    + Headers
    
            TOKEN: {authentication}

+ Response 204

### Mark a Message as read [PUT/PATCH /users/{user_id}/messages/{message_id}]

+ Parameters 

    + user_id (number) - The ID of the User who received the message. Can only update messages sent to the current logged user.
    + message_id (number) - The ID of the Message.

+ Request

    + Headers
    
            TOKEN: {authentication}

+ Response 200
