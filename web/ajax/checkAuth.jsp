<%@ page language="java" contentType="application/json;charset=UTF-8"%>
<%@page trimDirectiveWhitespaces="true"%>
<%@ page import="com.google.api.client.auth.openidconnect.IdToken,com.google.api.client.googleapis.auth.oauth2.GoogleIdToken,com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier,com.google.api.client.http.javanet.NetHttpTransport,com.google.api.client.json.jackson2.JacksonFactory,org.json.JSONObject,java.util.Arrays"%><%@ page import="smartcity.LoadProperties"%>
<%
    String clientID;
    if (request.getRequestURL().toString().contains(LoadProperties.properties.getString("WebsiteName"))) {
        clientID = LoadProperties.properties.getString("OAuthClientIDforWeb");
    }
    else {
        clientID = LoadProperties.properties.getString("OAuthClientIDforLocalHost");
    }

    //System.out.println(request.getRequestURL().toString());
    //System.out.println("Client ID " + clientID);
    JSONObject o = new JSONObject();

    try {
        String idTokenString = request.getParameter("id");
        // out.println (s);

        NetHttpTransport t = new NetHttpTransport();
        String CLIENT_ID = clientID;
        JacksonFactory jf = new JacksonFactory();
        GoogleIdTokenVerifier verifier = new GoogleIdTokenVerifier.Builder(t, jf)
        .setAudience(Arrays.asList(CLIENT_ID))
        // If you retrieved the token on Android using the Play Services 8.3 API or newer, set
        // the issuer to "https://accounts.google.com". Otherwise, set the issuer to
        // "accounts.google.com". If you need to verify tokens from multiple sources, build
        // a GoogleIdTokenVerifier for each issuer and try them both.
        .setIssuer("accounts.google.com")
        .build();

        GoogleIdToken idToken = verifier.verify(idTokenString);
        if (idToken != null) {
            IdToken.Payload payload = idToken.getPayload();

            // Print user identifier
            String userId = payload.getSubject();
            //System.out.println("User ID: " + userId);

            // Get profile information from payload
            String email = ((GoogleIdToken.Payload) payload).getEmail();
            boolean emailVerified = ((GoogleIdToken.Payload) payload).getEmailVerified();
            String name = (String) payload.get("name");

            if (emailVerified) {
                session.setAttribute("email", email);
                session.setAttribute("nameOfUser", name);
                o.put ("status", 0);
                o.put ("name", name);
                o.put ("email", email);
            }

          // String pictureUrl = (String) payload.get("picture");
          // String locale = (String) payload.get("locale");
          // String familyName = (String) payload.get("family_name");
          // String givenName = (String) payload.get("given_name");

        } else {
            o.put ("status", 1);
            o.put ("error", "Invalid ID token.");
        }
    } catch (Throwable e) {
        o.put ("status", 1);
        o.put ("error", e.toString());
    }

    out.println(o.toString());
%>