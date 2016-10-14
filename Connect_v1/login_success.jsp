<%-- 
    Document   : index
    Created on : 15 Jul, 2016, 6:11:12 PM
    Author     : sandeep
--%>

<% String pageName = "login"; %>
<%@include file="jspf/header.jspf" %>
<%@page import="
    java.io.BufferedReader,
    java.io.DataOutputStream,
    java.io.InputStreamReader,
    java.net.HttpURLConnection,
    java.net.URL,
    javax.net.ssl.HttpsURLConnection,
    org.json.*,
    java.util.Map"
%>
<%@page import="bridgeutil.BridgeCryptor"%>
<%@page import="bridgeutil.BridgeFactory"%>
<%@page import="bridgeutil.BridgePgUtil"%>

<%!
/**
 * send post method and get response
 */
public String sendPost(String url, String urlParameters) throws Exception {

        //--String url = "https://selfsolve.apple.com/wcResults.do";
        URL obj = new URL(url);
        //HttpsURLConnection con = (HttpsURLConnection) obj.openConnection();
        HttpURLConnection con = (HttpURLConnection) obj.openConnection();

        //add reuqest header
        con.setRequestMethod("POST");
        con.setRequestProperty("User-Agent", "Mozilla/5.0");
        con.setRequestProperty("Accept-Language", "en-US,en;q=0.5");

        //--String urlParameters = "sn=C02G8416DRJM&cn=&locale=&caller=&num=12345";

        // Send post request
        con.setDoOutput(true);
        DataOutputStream wr = new DataOutputStream(con.getOutputStream());
        wr.writeBytes(urlParameters);
        wr.flush();
        wr.close();

        int responseCode = con.getResponseCode();
        System.out.println("\nSending 'POST' request to URL : " + url);
        System.out.println("Post parameters : " + urlParameters);
        System.out.println("Response Code : " + responseCode);

        BufferedReader in = new BufferedReader(
                new InputStreamReader(con.getInputStream()));
        String inputLine;
        StringBuffer response = new StringBuffer();

        while ((inputLine = in.readLine()) != null) {
                response.append(inputLine);
        }
        in.close();

        //print result
        return response.toString();

    }
%>
<section id="inner-headline">
	<div class="container">
		<div class="row">
			<div class="col-lg-12">
				<ul class="breadcrumb">
					<li><a href="index.jsp">Home</a><i class="icon-angle-right"></i></li>
					<li class="active">Login</li>
				</ul>
			</div>
		</div>
	</div>
	</section>
	<section id="content">
<div class="container">

<div class="row">

	<div class="col-lg-6">
	<!-- call response -->
        <%

            String resp  = request.getQueryString();
            String state_saved = (String)session.getAttribute("state");
            String state_req = request.getParameter("state");
            BridgePgUtil bc = new BridgePgUtil();
            String formattedClientSecret = bc.formClientSecret(clientSecret, accessToken);
            if(state_saved == null || state_req == null || !state_saved.equals(state_req) ){
                resp = "State mismatched! Please try to login again.:";// + state_saved + ":" + resp+ "::" +state_req;
            } else {
                String code = request.getParameter("code");
                //resp = code;
                if(code == null || code.length() <= 0){
                    resp = "Error!! Code not received from server!";
                } else {
                    //jsp post a request ..
                    String url = tokenAddress;
                    String parameters = 
                            "code=" + code + "&" +
                            "redirect_uri=" + redirectUri + "&" +
                            "grant_type=authorization_code&" +
                            "client_id=" + clientId + "&" +
                            "client_secret=" + formattedClientSecret;//ee0f2b2fd3b57e1ddc0e71c24eafdd57";
                    try{
                        String ret = sendPost(url, parameters);
                        JSONObject tResp = new JSONObject(ret);
                        String token = tResp.getString("access_token");
                        
                        parameters = "access_token=" + token;
                        resp = sendPost(resourceAddress, parameters);
                        
                        JSONObject obj = new JSONObject(resp);
                        JSONObject user = obj.getJSONObject("User");
                        
                        Map<String, Object> mVals = user.toMap();
                        resp = "\n<br>----User Details ----";
                        for (Map.Entry<String, Object> entry : mVals.entrySet()) {
                            System.out.println("Key = " + entry.getKey() + ", Value = " + entry.getValue());
                            resp += "\n" + entry.getKey() + " : " + entry.getValue();
                        }
                        session.setAttribute("username", mVals.get("username"));
                    }catch(Exception ec){out.write(ec.toString());}
                }
            }
            
            //String code  = session.getAttribute("code").toString();
        %>
	<h4>Digital Seva Connect Response</h4>
				<pre class="prettyprint linenums">
					print the response string 
					
					Encrypted Values: <%= resp %> 
					
					<br>
					
					Decrypted Values:
				</pre>
				
				
	
	
	
	</div>

	<div class="col-lg-6">
		<div class="col-xs-12 col-sm-8 col-md-6 col-sm-offset-2 col-md-offset-3">
                    <%
                        //String serverAddress = "http://connect.csccloud.in/account/authorize";
//                        String serverAddress  = "http://localhost/sandeep/oauth2/index.php/account/authorize";
//                        String clientId       = "c5a27156-d4a2-418e-a7a9-86f26be6862c";
//                        String clientSecret   = "testpass";
//                        String redirectUri    = "http://localhost:8080/javamerchant/login_success.jsp";
//                       String accessToken    = "32zDIHeOPeVunekZ";
                        
//                        String state = "" + (int)(Math.random() * 1000000);
//                        session.setAttribute("state",state);
//                        String connect_url =
//                                serverAddress +
//                                "?state=" +
//                                state +
//                                "&response_type=code&client_id=" +
//                                clientId +
//                                "&redirect_uri=" +
//                                redirectUri;
                    %>
			
			<br><br>
		
		</div>
	</div>
</div>

</div>
	</section>

<%@include file="jspf/footer.jspf" %>
