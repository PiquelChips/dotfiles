Hello, I am currently refactoring the authentication system for my API to make it more robust and more secure.
I need your help to design the session management. I am a solo developer and very new to this. If you think my
ideas will not work, do not fit my usecase or are too complex to implement, please tell me I am open to feedback.

Here is how I want it to work:
The user should store a JWT in a cookie. This allows the API to directly get user data without needing to query the database.
I would also like this JWT to work like a session token, namely I want a way for it to expire, and be able to revoke it without
needing to access the client in question (this might mean storing in the database, which goes against the point of using a JWT
in the first place). The last problem I have is updating the user. Currently I only store the userId (which is immutable) in the
JWT, and then query the DB for the rest of the user object. The reason I don't also store the user is that when the user is updated,
the JWT does not get the updated data, so on the next API call, it would use old data (I have heard about something called
"refresh tokens", maybe they'll help?).

Here is a quick description of my stack for context:
I use a Golang net/http server for the backend. It handles OAuth flows (and webauthn in the future) and all of the actual API stuff
(so the features of my app). After authentication, the API redirects to the frontend with the JWT as a query parameter. The frontend
then saves the JWT in a cookie. When calling the API, the frontend hooks every API call and adds the `Authorization: Bearer <token>`
header to every request. Thus the API does not set the cookie itself. The frontend is SvelteKit.

Could you help give me a design for how the session management should work for my website. If any of the design
desitions/suggestions I have made seem problematic or unoptimized, feel free to make changes. For now, I do not need
concrete implementations, I just need to understand how it is done.
