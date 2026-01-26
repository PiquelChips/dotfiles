# 1

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
header to every request. Thus the API does not set the cookie itself. The frontend is SvelteKit. The reason I do this is that
when the client first makes a request, the API is called on by the SvelteKit server (for SSR). Thus, the cookie will not directly 
be passed to SvelteKit and thus the API.

Could you help give me a design for how the session management should work for my website. If any of the design
desitions/suggestions I have made seem problematic or unoptimized, feel free to make changes. For now, I do not need
concrete implementations, I just need to understand how it is done.

# 2

Thank you! I will go for the client-side interceptor stratgey. Could you please write all the client-side handling of
this new system (with the refresh system and all that). I currently use openapi-fetch as a client for API calls. Here is the code:

`./src/lib/api/client.ts`
```js
import createClient, { type Middleware } from "openapi-fetch";
import type { paths as profilePaths } from "./gen/profile.d.ts";
import type { paths as emailPaths } from "./gen/email.d.ts";
import { PUBLIC_API } from "$env/static/public";
import { browser } from "$app/environment";
import { error, redirect } from "@sveltejs/kit";
import { page } from "$app/state";

function getToken() {
    if (!browser) return null;

    const cookies = document.cookie.split(";");
    const jwt = cookies.find((cookie: string) =>
        cookie.trim().startsWith("jwt=")
    );

    return jwt ? jwt.split("=")[1] : null;
}

const middleware: Middleware = {
    onRequest({ request }) {
        const token = getToken();
        request.headers.set("Authorization", `Bearer ${token}`);
        return request;
    },
    async onResponse({ response }) {
        switch (response.status) {
            case 200:
                break;
            case 401:
                redirect(
                    307,
                    `/auth/login?redirectTo=${page ? page.url.pathname : ""}`,
                );
                break;
            default:
                error(response.status, { message: await response.text() });
                break;
        }
    },
    onError({ error }) {
        return new Error(`API Error: ${error}`);
    },
};

export const profile = createClient<profilePaths>({
    baseUrl: `${PUBLIC_API}/profile`,
});
export const email = createClient<emailPaths>({
    baseUrl: `${PUBLIC_API}/email`,
});

const clients = [profile, email];

for (const client of clients) {
    client.use(middleware);
}
```

I don't want to have to add per-call handling, it should all automatically be handled. I can't be thinking of
needing to refresh tokens every time I call the API. It would probably be helpful use the middlewares.
