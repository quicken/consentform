<cfset template = getTemplate()>

<cfif CGI.REQUEST_METHOD EQ "post">
	<cfset guid = createGUID()>
	<cfset path = getTempDirectory()/>
	<cfset imgName = guid & ".png">
	<cfset imageWrite(imageReadBase64(form.imgData),path & imgName)>
	<cfset generatePDF(template,imgName)>
<cfelse>
	<cfset pName = isDefined('pName') ? pName : "">
	<cfset pEmail = isDefined('pEmail') ? pEmail : "">
	<cfset rName = isDefined('rName') ? rName : "">
    <cfoutput>#displayTemplate(template,'view','')#</cfoutput>
</cfif>



<cffunction name="generatePDF" returntype="void">
    <cfargument name="template" required="true" type="string">
    <cfargument name="imgName" required="true" type="string">
    <cfset var html = displayTemplate(arguments.template,"print",imgName)>
    <cfset var i = 0>
	<cfset var w = "">
	<cfset var pdf_name = "uq_consent_" & dateFormat(now(),'YYYY_MM_DD') & "-" & timeFormat(now(),"HH-MM") & ".pdf">

	<cfheader name="Content-Disposition" value="attachment; filename=#pdf_name#">
	<cfdocument backgroundvisible="true"
				unit="cm"
				margintop="1.8"
				marginleft="1.0"
				marginright="1.0"
				format="PDF"
				pagetype="a4">

	<cfoutput>#html#</cfoutput></cfdocument>
</cffunction>


<cffunction name="getTemplate" output="false" returntype="string">
    <cfset template = "">
    <cffile action="read" file="template.cfm" variable="template">
	<cfreturn template>
</cffunction>


<cffunction name="displayTemplate" output="false" returntype="string">
    <cfargument name="template" type="string">
    <cfargument name="media" type="string">
    <cfargument name="imgName" type="string" required="false" default="">
    <cfset var formContent = arguments.media EQ "print" ? formPrintView(arguments.imgName): formInputView()>
    <cfset var content = ""> 
    <cfset var html = "">
    <cfif arguments.media EQ "view">
		<cfset arguments.template = replaceNoCase(arguments.template,'src="/','src="///#CGI.http_host#/','all')>
		<cfset content = replaceNoCase(arguments.template,'<!--INSERTFORM-->',formContent,'one')> 
    <cfsavecontent variable="html"><cfoutput><!DOCTYPE html>
<html>
    <head>
        <meta charset = "UTF-8">
        <title>Research Consent</title>
        <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,700&display=swap" rel="stylesheet">
        <link rel="stylesheet" type="text/css" href="/style/reset.css"/>
        <link rel="stylesheet" type="text/css" href="/style/main.css"/>
    </head>
    <body>
        #content#
        <script language="JavaScript" type="text/javascript" src="/script/lib/jquery/jquery-3.4.1.min.js"></script>
        <script language="JavaScript" type="text/javascript" src="/script/lib/jSignature/jSignature.min.js"></script>
        <script language="JavaScript" type="text/javascript" src="/script/main.js"></script>
        <script type="text/javascript">$(document).ready(function(){controller.init();});</script>
    </body>
</html></cfoutput></cfsavecontent>
    <cfelse>
		<cfset arguments.template = replaceNoCase(arguments.template,'src="/','src="http://127.0.0.1:8888/','all')>
		<cfset content = replaceNoCase(arguments.template,'<!--INSERTFORM-->',formContent,'one')> 
    <cfsavecontent variable="html"><cfoutput><html lang="en">
	<head>
	  	<meta charset="utf-8">
	  	<title>Research Consent Form</title>
		<link href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,700&display=swap" rel="stylesheet">
		<link rel="stylesheet" type="text/css" href="http://127.0.0.1:8888/style/reset.css"/>
		<link rel="stylesheet" type="text/css" href="http://127.0.0.1:8888/style/print.css"/>
		<style>
		##sig{width:100mm;}
		</style>
	</head>
	<body>
        #content#
    </body>
</html></cfoutput></cfsavecontent>
    </cfif>

    <cfreturn trim(html)>
</cffunction>


<cffunction name="formInputView" output="false" returntype="string">
    <cfset var html = "">
    <cfsavecontent variable="html"><cfoutput>
    <form id="consentForm" action="/index.cfm" method="post">
        <input type="hidden" id="sigData" name="imgData">
        <p>
            <label>Researcher Name:</label><br>
            <cfoutput><input name="rName" value="#HTMLEditFormat(rName)#"></cfoutput>
        </p>
        <p>
            <label>Participant Name:</label><br>
            <cfoutput><input name="pName" value="#HTMLEditFormat(pName)#"></cfoutput>
        </p>
        <p>
            <label>Participant Email:</label><br>
            <cfoutput><input name="pEmail" value="#HTMLEditFormat(pEmail)#"></cfoutput>
        </p>
        
        Signature: (Write signature with mouse / pointer / finger) <button id="btnReset">Reset Signature</button>
        <div id="signature"></div>

        <button id="btnSave">Generate PDF</button>
    </form>
    </cfoutput></cfsavecontent>

    <cfreturn trim(html)>
</cffunction>


<cffunction name="formPrintView" output="false" returntype="string">
    <cfargument name="imgName" type="string">
    <cfset var html = "">
    <cfset var path = getTempDirectory()/>
    <cfsavecontent variable="html"><cfoutput>
<p>
    Participant Name: <span class="underline">#HTMLEditFormat(form.pName)#</span>
</p>
<p>
    Participant Email: <span class="underline">#HTMLEditFormat(form.pEmail)#</span>
</p>
<div id="sigbox">
    Participant Signature:
    <div id="sigDate">Date: #dateFormat(now(),'DD/MM/YYYY')#</div>
    <img id="signature" src="file://#path##arguments.imgName#">
</div>

<p>
    Researcher Name: <span class="underline">#HTMLEditFormat(form.rName)#</span>
</p>

<p style="margin-top:5mm;">
    Researcher Signature: <span class="underline"></span> Date: _____/_____/ 2020
</p>

<p style="margin-bottom:2mm;">
    <strong>Researchers</strong>
</p>
<p>
    <span class="underline"></span>
</p>
<p>
    <span class="underline"></span>
</p>
<p>
    <span class="underline"></span>
</p>
    </cfoutput></cfsavecontent>
    
    <cfreturn trim(html)>
</cffunction>