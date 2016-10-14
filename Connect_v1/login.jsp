<%-- 
    Document   : index
    Created on : 15 Jul, 2016, 6:11:12 PM
    Author     : sandeep
--%>
<% String pageName = "login"; %>
<%@include file="jspf/header.jspf" %>

	<section id="inner-headline">
	<div class="container">
		<div class="row">
			<div class="col-lg-12">
				<ul class="breadcrumb">
					<li><a href="index.html">Home</a><i class="icon-angle-right"></i></li>
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
	
	<h4>Digital Seva Connect Response</h4>
				<pre class="prettyprint linenums">
					print the response string 
					
					Encrypted Values:  
					
					<br>
					
					Decrypted Values:
				</pre>
				
				
	
	
	
	</div>

	<div class="col-lg-6">
		<div class="col-xs-12 col-sm-8 col-md-6 col-sm-offset-2 col-md-offset-3">
                    <%
                        String state = "" + (int)(Math.random() * 1000000);
                        session.setAttribute("state", state);
                        String connect_url =
                                authorizationAddress             +
                                "?state="                        +
                                state                            +
                                "&response_type=code&client_id=" +
                                clientId                         +
                                "&redirect_uri="                 +
                                redirectUri;
                    %>		
                    <a href="<%= connect_url %>" class="btn btn-info">Login with Digital Seva Connect</a>
			
			<br><br>
		
		
			<form role="form" class="register-form">
				<h3>Sign in </h3>
				<hr class="colorgraph">

				<div class="form-group">
					<input type="email" name="email" id="email" class="form-control input-lg" placeholder="Email Address" tabindex="4">
				</div>
				<div class="form-group">
					<input type="password" class="form-control input-lg" id="exampleInputPassword1" placeholder="Password">
				</div>

				
				<div class="row">
					<div class="col-xs-12 col-md-6"><input type="submit" value="Sign in" class="btn btn-success btn-block btn-lg" tabindex="7"></div>
					
				</div>
			
			</form>
		</div>
	</div>
</div>

</div>
	</section>

<%@include file="jspf/footer.jspf" %>
