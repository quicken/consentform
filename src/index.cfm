<cfif CGI.REQUEST_METHOD EQ "post">
	<cfset guid = createGUID()>
	<cfset path = expandPath("./") & 'gfx/sigs/'/>
	<cfset imgName = guid & ".png">
	<cfset imageWrite(imageReadBase64(form.imgData),path & imgName)>
	<cfset generatePDF(imgName)>
<cfelse>
	<cfset pName = isDefined('pName') ? pName : "">
	<cfset pEmail = isDefined('pEmail') ? pEmail : "">
	<cfset rName = isDefined('rName') ? rName : "">
	<!DOCTYPE html>
	<html>
		<head>
			<meta charset = "UTF-8">
			<title>DECO7250 - Research Consent</title>
			<link href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,700&display=swap" rel="stylesheet">
			<link rel="stylesheet" type="text/css" href="/style/reset.css"/>
			<link rel="stylesheet" type="text/css" href="/style/main.css"/>
		</head>
		<body>
	<div id="page">
		<div id="heading">
			<img id="uqlogo" src="/gfx/university-of-queensland.png">
		</div>
		<table id="header">
			<tbody>
				<tr>
					<td>
						<h2>School of Information Technology and Electrical Engineering</h2>
						<div>
							<strong>HEAD OF SCHOOL</strong><br>
							Professor Amin Abbosh
						</div>
					</td>
					<td>
						The University of Queensland<br>
						Brisbane Qld 4072 Australia<br>
						Telephone +61 7 3365 2097<br>
						Facsimile +61 7 3365 4999<br>
						Email enquiries@itee.uq.edu.au<br>
						Internet www.itee.uq.edu.au<br>
					</td>
				</tr>
			</tbody>
		</table>
		<div id="main">
			<h1>Informed consent form</h1>
			<h2>User interface testing for DECO2500/7250 class exercise</h2>
			<p>
				This user testing exercise is for educational purposes only, and is being conducted as a course requirement
				for DECO2500/7250, a course about human-computer interaction.
			</p>
			<p>
				You will be asked to interact with a paper prototype, computer program or system, and/or to answer questions about
				your interaction. We are testing the design; we are not testing you in any way. The test will require no more than an
				hour of your time, and potentially less.
			</p>
			<p>
				Consent is voluntary – you do not have to participate if you don’t want to. If you do participate, you may
				withdraw your consent at any point, and all your data up to that point will be destroyed and not used.
			</p>
			<p>
				All data collected is confidential and will be kept in a secure location, and your data will
				be indexed by a participant ID rather than by name.
			</p>
			<p>
				If AV recordings are taken, they will be seen only by the students doing this particular project and
				possibly also by their Studio tutors and the course coordinator (Dr Chelsea Dobbins).
			</p>
			<p>
				All your data, including any recordings, will be erased/destroyed once class grades are released.
			</p>
			<p>
				There is no reimbursement or payment for participation.
			</p>

			<p>
				<strong>I have read the information above and give my consent to participate.</strong>
			</p>
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

			<p>
				Instructor in charge of DECO2500/7250: Dr Chelsea Dobbins, School of ITEE, UQ (c.m.dobbins@uq.edu.au)
			</p>
			<p>
				Because this is an in-class educational exercise, performed by course students with UQ students,
				family or friends only, formal ethics approval has not been sought.
			</p>
		</div>
	</div>
			<script language="JavaScript" type="text/javascript" src="/script/lib/jquery/jquery-3.4.1.min.js"></script>
			<script language="JavaScript" type="text/javascript" src="/script/lib/jSignature/jSignature.min.js"></script>
			<script language="JavaScript" type="text/javascript" src="/script/main.js"></script>
			<script type="text/javascript">$(document).ready(function(){controller.init();});</script>
		</body>
	</html>
</cfif>






<cffunction name="generatePDF" returntype="string">
	<cfargument name="imgName" required="true" type="string">
	<cfset var i = 0>
	<cfset var w = "">
	<cfset var html = "">
	<cfset var pdf_name = "uq_consent_" & dateFormat(now(),'YYYY_MM_DD') & "-" & timeFormat(now(),"HH-MM") & ".pdf">

	<cfheader name="Content-Disposition" value="attachment; filename=#pdf_name#">
	<cfdocument backgroundvisible="true"
				unit="cm"
				margintop="1.8"
				marginleft="1.0"
				marginright="1.0"
				format="PDF"
				pagetype="a4">

	<cfoutput><html lang="en">
	<head>
	  	<meta charset="utf-8">
	  	<title>DECO7250 - Research Consent Form</title>
		<link href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,700&display=swap" rel="stylesheet">
		<link rel="stylesheet" type="text/css" href="http://127.0.0.1:8888/style/reset.css"/>
		<link rel="stylesheet" type="text/css" href="http://127.0.0.1:8888/style/print.css"/>
		<style>
		##sig{width:100mm;}
		</style>
	</head>
	<body>
		<div id="page">
	<div id="heading">
		<img id="uqlogo" src="http://127.0.0.1:8888/gfx/university-of-queensland.png">
	</div>
	<table id="header">
		<tbody>
			<tr>
				<td>
					<h2>School of Information Technology and Electrical Engineering</h2>
					<div>
						<strong>HEAD OF SCHOOL</strong><br>
						Professor Amin Abbosh
					</div>

				</td>
				<td>
					The University of Queensland<br>
					Brisbane Qld 4072 Australia<br>
					Telephone +61 7 3365 2097<br>
					Facsimile +61 7 3365 4999<br>
					Email enquiries@itee.uq.edu.au<br>
					Internet www.itee.uq.edu.au<br>
				</td>
			</tr>
		</tbody>
	</table>
	<div id="main">
		<h1>Informed consent form</h1>
		<h2>User interface testing for DECO2500/7250 class exercise</h2>
		<p>
			This user testing exercise is for educational purposes only, and is being conducted as a course requirement
			for DECO2500/7250, a course about human-computer interaction.
		</p>
		<p>
			You will be asked to interact with a paper prototype, computer program or system, and/or to answer questions about
			your interaction. We are testing the design; we are not testing you in any way. The test will require no more than an
			hour of your time, and potentially less.
		</p>
		<p>
			Consent is voluntary – you do not have to participate if you don’t want to. If you do participate, you may
			withdraw your consent at any point, and all your data up to that point will be destroyed and not used.
		</p>
		<p>
			All data collected is confidential and will be kept in a secure location, and your data will
			be indexed by a participant ID rather than by name.
		</p>
		<p>
			If AV recordings are taken, they will be seen only by the students doing this particular project and
			possibly also by their Studio tutors and the course coordinator (Dr Chelsea Dobbins).
		</p>
		<p>
			All your data, including any recordings, will be erased/destroyed once class grades are released.
		</p>
		<p>
			There is no reimbursement or payment for participation.
		</p>

		<p>
			<strong>I have read the information above and give my consent to participate.</strong>
		</p>

		<p>
			Participant Name: <span class="underline">#HTMLEditFormat(form.pName)#</span>
		</p>
		<p>
			Participant Email: <span class="underline">#HTMLEditFormat(form.pEmail)#</span>
		</p>
		<div id="sigbox">
			Participant Signature:
			<div id="sigDate">Date: #dateFormat(now(),'DD/MM/YYYY')#</div>
			<img id="signature" src="http://127.0.0.1:8888/gfx/sigs/#arguments.imgName#">
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

		<p>
			Instructor in charge of DECO2500/7250: Dr Chelsea Dobbins, School of ITEE, UQ (c.m.dobbins@uq.edu.au)
		</p>
		<p>
			Because this is an in-class educational exercise, performed by course students with UQ students,
			family or friends only, formal ethics approval has not been sought.
		</p>
	</div>
</div>
		<div>

		</div>
	</body>
	</html></cfoutput>
	</cfdocument>

	<cfreturn trim(html)>
</cffunction>
