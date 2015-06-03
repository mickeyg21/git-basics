<!DOCTYPE html>
<html lang="en">
<head>
<meta charset=utf-8" />
<title>AFI TEST PAGE</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="bootstrap/css/styles.css">
<meta name="viewport" content="width=device-width, initial-scale=1">
</head>

<cfparam name="url.search" type="string" default="">
<cfparam name="results" type="boolean" default="False">
<cfparam name="valid" type="boolean" default="True"> 

<!--- if form is submitted, include validation page --->
<cfif isDefined('form.gosearch')>
	<cfinclude template="lookup.cfm">
</cfif>
<div class= "container-fluid">
<div class="row">
<div class="col-sm-4 well">

<div class="col-sm-2 well">
</div>
<div class="col-sm-6 well">
<cfif IsDefined('url.vsvencode')>
<!---do nothing--->
<cfelse>
<cfset url.vsvencode = "">
</cfif> 
 
 <cfform action="po_action.cfm" method = "post" >
	
<!--- <table> --->

	
 <h3>Purchase Order Search Form </br>(Advantage 3 Only)</h3> 

<table>
	<tr>
		 <td>Vendor Code:</td>
		 
 <cfif '#url.vsvencode#' is ""> 
		<td><cfinput type="Text" id="vencode" class="form-control sm" placeholder="optional (eg. hom6045500)" name="vencode" message="You must enter a Vendor Code."  size="12"  maxlength="12"></td><td><i><font size="-1"></font></i></td>
		<cfelse>

		<!---If Vencode is not spaces, populate the value with the url.vsvencode.  this saves the user from having to key it in--->

		
		 <td><input type="Text" id="vencode" "name="vencode" value="#vsvencode#" size="12" maxlength="10"></td> 
		
</cfif>
	

<cfoutput>

<h3>Vendor Name/Code Search</h3> 
<form name="vendor" action="index.cfm?search=vendor" method="post">
		
			<label for="vsvenname">Search Vendor Name / Code</label>
			<input name="vsvenname" id="vsvenname" type="text" maxlength="10" placeholder="Enter Vendor Name or Number" <cfif isDefined('form.vsvenname')>value="#form.vsvenname#"</cfif>>
		
		
			<input type="hidden" name="gosearch" value="go">
			<input id="submit" type="Submit" name="search" value="Search"></br></br>
		
	</form>

</div><!--end row -->
</div><!--end col-sm-6-->
</div><!--end container--> 	
</cfoutput>  



















		
			
	<!--- </tr> --->
	
	<!---This is the vendor address indicator input--->
		
	<!---This is the Invoice number input--->
	
	<!---This is the Purchase Order Input--->
	
	
	<TR>
  		<TD>PO Type:</TD>
		<TD><select name="POType" class="form-control responsive">
				<option value="all" selected class="well-sm">All
				<option value="CT">CT
				<option value="CTM">CTM
				<option value="PO">PO
				<option value="DO">DO
				<option value="DOM">DOM
				<option value="CBDL">CBDL
			</SELECT>
		</TD>
		<td></td>
  	</TR>
	
	
	<tr>
		<td>Doc Dept Code:</td>
		<td><input type="Text" name="dept" placeholder="optional (eg. 7400)" size="4" maxlength="4" ></td>
		<td></td>
	</tr>
	
	
	
	<!---This is the Payment Voucher Input--->
	
	<tr>
		<td>DOC ID:</td>
		<td><input type="text" name="doc_id" placeholder="optional (eg. 07110503309)" size="20" maxlength="20"></td>
<td></td>
	</tr>
	
	<tr>
		<td>Comm. Description <strong>OR</strong> Code:</td>
		<td><input type="Text" placeholder="optional (eg. computer or 91829)" name="CommDescription"  size="30" maxlength="30" ></td>
<td></td>
	</tr>
	
	
	
	<tr>
		<td>Master Agreement (MA):</td>
		<td><input type="Text" placeholder="optional (eg. S030396)" name="MA"  size="14"maxlength="14" ></td>
<td></td>
	</tr>
	
	<tr>
		<td>Budget Fiscal Year:</td>
		<td><input type="Text" name="BFY" placeholder="optional (eg. 2007)"   size="4"maxlength="4" ></td>
<td></td>
	</tr>
	
</table>


<!---This is where the date range starts--->


	
	<table>
			
	<tr>
		<tr>Purchase Order Date Range:</tr>
		<br />
		
<tr>
	<label>Date From</label><input name="FromDate" placeholder=" Enter mm/dd/yyyy" type="text" maxlength="10"> 
	
			
			
		
			<label>Date To</label>
			<input name="ToDate" placeholder="Enter mm/dd/yyyy" type="text" maxlength="10">	</tr>
		
</table>



<table>

<tr>
  	<b><TR>Purchase Order Status</tr></b>
	<td><CFINPUT type = "Radio" name = "status" value="open" checked="Yes">Open Purchase Orders&nbsp;
	    <CFINPUT type = "Radio" name = "status" value ="closed">Closed Purchase Orders&nbsp;
  	   <cfinput type="Radio" name="status" value="all" >All Purchase Orders</td>
</TR>

<tr>
<td>
<input class="btn btn-primary pull-right"type="submit" value="Search" onClick="this.form.submit();this.disabled='true';this.value='Please wait while your request is processed';">
</td>
<td>&nbsp</td>
</tr>
	
</table>
	
</cfform>
 

<cfif results and valid> 

<div class="col-md-5"> 
  
    <h3>Search Results (Please select from the Vendor ID below)
			

<cfinclude template="search_results.cfm"> 

	

</cfif>  


<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/js/bootstrap.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
<script src="bootstrap/js/myscript.js"></script>
</body>
</html>
