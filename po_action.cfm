<!---payment for oracle--->

<!--- If this form was accessed directly without going through
the add form, this will send the user to the payments entry form.
Otherwise, continue --->

<cfif IsDefined("dept")>
	<!---do nothing--->
<cfelseif isdefined("start")>
	<!---do nothing--->
<cfelse>
	<cflocation url="index.cfm">
</cfif>



<!---Initialize all fields if they do not exist--->
<cfparam name="start" default="1">
<cfset message3 = "none3">
<cfset message6 = "none6">
<cfset message2 = "none2">
<cfset message7 = "none7">

<!---test to see if all fields are blank. If so, set message. --->
<cfif (FORM.vencode EQ '') AND (FORM.doc_id EQ '') AND (FORM.dept is '') AND (FORM.commdescription EQ '') AND (FORM.fromdate EQ '') AND (FORM.todate EQ '') AND (FORM.ma EQ '')>
	<cfset message3 = "CV">

<!---test to see if just the dates are entered.  If so, issue message.--->
<cfelseif (FORM.vencode EQ '') AND (FORM.doc_id EQ '') AND  (FORM.dept EQ '') AND (FORM.commdescription EQ '') AND (FORM.ma EQ '') AND (FORM.fromdate NEQ '') AND (form.todate NEQ '')>
	<cfset message6 = "CZ">

<!---test to see if a date range field is entered and one is blank.  IF so return message where record count is set to "E" and stop --->
<cfelseif ((FORM.fromdate NEQ '') AND (FORM.todate EQ '')) OR ((FORM.fromdate EQ '') AND (form.todate NEQ ''))>
	<cfset message2 = "de">

<cfelseif (FORM.vencode EQ '') AND (FORM.doc_id EQ '') AND  (FORM.dept EQ '') AND  (FORM.ma EQ '') AND (#mid(FORM.commdescription,4,1)# EQ '') AND ((#mid(FORM.commdescription,1,1)# NEQ '') OR (#mid(FORM.commdescription,2,1)# NEQ '') OR (#mid(FORM.commdescription,3,1)# NEQ '')) >
	<cfset message7 = "ZZ">

<cfelse>
	<cfif FORM.status EQ 'OPEN'>
		<cfquery name="po_query" datasource="fasdprod_fasdscan">
		SELECT		po_doc_hdr.doc_cd,
					po_doc_hdr.doc_dept_cd,
					po_doc_hdr.doc_id,
					po_doc_vend.vend_cust_cd,
					po_doc_vend.LGL_NM,
					po_doc_hdr.doc_rec_dt_dc,
					po_doc_hdr.doc_clsd_dt,
					po_doc_hdr.agree_doc_cd,
					po_doc_hdr.agree_doc_dept_cd,
					po_doc_hdr.agree_doc_id,
					po_doc_hdr.doc_actu_am,
					po_doc_hdr.clsd_am,
					- sum(check_paydetail.amount)as expended,
					(po_doc_hdr.doc_actu_am - po_doc_hdr.clsd_am) as outstandingamt

		FROM		aims36.po_doc_hdr,
					aims36.po_doc_vend,
					aims36.po_doc_comm,
					aims36.check_paydetail

		WHERE 		((po_doc_hdr.doc_cd = po_doc_vend.doc_cd)
		AND			(po_doc_hdr.doc_id = po_doc_vend.doc_id)
		AND			(po_doc_hdr.doc_dept_cd = po_doc_vend.doc_dept_cd)
		AND			(po_doc_hdr.doc_vers_no = po_doc_vend.doc_vers_no)
		AND			(po_doc_hdr.doc_phase_cd = po_doc_vend.doc_phase_cd)
		AND			(po_doc_vend.doc_cd = po_doc_comm.doc_cd)
		AND			(po_doc_vend.doc_id = po_doc_comm.doc_id)
		AND			(po_doc_vend.doc_dept_cd = po_doc_comm.doc_dept_cd)
		AND			(po_doc_vend.doc_vers_no = po_doc_comm.doc_vers_no)
		AND			(po_doc_vend.doc_phase_cd = po_doc_comm.doc_phase_cd)
		AND			(po_doc_vend.doc_vend_no = po_doc_comm.doc_vend_no)
		AND			(po_doc_vend.doc_vend_ln_no = po_doc_comm.doc_vend_ln_no)
		AND			(po_doc_hdr.doc_func_cd <> 3)
		AND			(po_doc_hdr.doc_phase_cd = 3)
		AND			(po_doc_comm.doc_cd = check_paydetail.rf_doc_cd(+))
		AND			(po_doc_comm.doc_id = check_paydetail.rf_doc_id(+))
		AND			(po_doc_comm.doc_dept_cd = check_paydetail.rf_doc_dept_cd(+))
		AND			(po_doc_comm.doc_comm_ln_no = check_paydetail.rf_doc_comm_ln_no(+))
		AND			(po_doc_comm.doc_vend_ln_no = check_paydetail.rf_doc_vend_ln_no(+))
		AND			(po_doc_hdr.doc_actu_am - po_doc_hdr.clsd_am) > 0

<cfif FORM.vencode NEQ ''>
		AND			po_doc_vend.vend_cust_cd = 	'#ucase(FORM.vencode)#'
</cfif>

<cfif FORM.potype NEQ 'ALL'>
		AND			po_doc_hdr.doc_cd = '#FORM.potype#'
</cfif>

<cfif FORM.dept NEQ ''>
		AND			po_doc_hdr.doc_dept_cd  = '#ucase(FORM.dept)#'
</cfif>

<cfif FORM.doc_id NEQ ''>
		AND			po_doc_hdr.doc_id = '#ucase(FORM.doc_id)#'
</cfif>

<cfif FORM.ma NEQ ''>
		AND			po_doc_hdr.agree_doc_id  = '#ucase(FORM.ma)#'
</cfif>

<cfif FORM.bfy NEQ ''>
		AND			po_doc_hdr.doc_bfy = #ucase(FORM.bfy)#
</cfif>

<cfif FORM.commdescription NEQ ''>
		AND			(((UPPER(po_doc_comm.comm_dscr) LIKE '%#ucase(FORM.commdescription)#%') OR
					(UPPER(po_doc_comm.cl_dscr_up) LIKE '%#ucase(FORM.commdescription)#%')) OR
					(UPPER(po_doc_comm.comm_cd) LIKE '%#ucase(FORM.commdescription)#%'))
</cfif>

<cfif FORM.fromdate NEQ ''>
		AND			po_doc_hdr.doc_rec_dt_dc between To_Date('#DateFormat(FORM.fromdate,"MM/DD/YYYY")#','mm/dd/yyyy')
		AND			To_Date('#DateFormat(FORM.todate,"MM/DD/YYYY")#','mm/dd/yyyy')
</cfif>
)

		GROUP BY	po_doc_hdr.doc_cd,
					po_doc_hdr.doc_dept_cd,
					po_doc_hdr.doc_id,
					po_doc_vend.vend_cust_cd,
					po_doc_vend.LGL_NM,
					po_doc_hdr.doc_rec_dt_dc,
					po_doc_hdr.doc_clsd_dt,
					po_doc_hdr.agree_doc_cd,
					po_doc_hdr.agree_doc_dept_cd,
					po_doc_hdr.agree_doc_id,
					po_doc_hdr.doc_actu_am,
					po_doc_hdr.clsd_am,
					(po_doc_hdr.doc_actu_am - po_doc_hdr.clsd_am)

		ORDER BY	po_doc_hdr.doc_rec_dt_dc DESC
		</cfquery>

	<cfelseif FORM.status EQ 'CLOSED'>
		<cfquery name="po_query" datasource="#APPLICATION.ds#">
		SELECT		po_doc_hdr.doc_cd,
					po_doc_hdr.doc_dept_cd,
					po_doc_hdr.doc_id,
					po_doc_vend.vend_cust_cd,
					po_doc_vend.LGL_NM,
					po_doc_hdr.doc_rec_dt_dc,
					po_doc_hdr.doc_clsd_dt,
					po_doc_hdr.agree_doc_cd,
					po_doc_hdr.agree_doc_dept_cd,
					po_doc_hdr.agree_doc_id,
					po_doc_hdr.doc_actu_am,
					po_doc_hdr.clsd_am,
					- sum(check_paydetail.amount)as expended,
					(po_doc_hdr.doc_actu_am - po_doc_hdr.clsd_am) as outstandingamt

		FROM		aims36.po_doc_hdr,
					aims36.po_doc_vend,
					aims36.po_doc_comm,
					aims36.check_paydetail

		WHERE		((po_doc_hdr.doc_cd = po_doc_vend.doc_cd)
		AND			(po_doc_hdr.doc_id = po_doc_vend.doc_id)
		AND			(po_doc_hdr.doc_dept_cd = po_doc_vend.doc_dept_cd)
		AND			(po_doc_hdr.doc_vers_no = po_doc_vend.doc_vers_no)
		AND			(po_doc_hdr.doc_phase_cd = po_doc_vend.doc_phase_cd)
		AND			(po_doc_vend.doc_cd = po_doc_comm.doc_cd)
		AND			(po_doc_vend.doc_id = po_doc_comm.doc_id)
		AND			(po_doc_vend.doc_dept_cd = po_doc_comm.doc_dept_cd)
		AND			(po_doc_vend.doc_vers_no = po_doc_comm.doc_vers_no)
		AND			(po_doc_vend.doc_phase_cd = po_doc_comm.doc_phase_cd)
		AND			(po_doc_vend.doc_vend_no = po_doc_comm.doc_vend_no)
		AND			(po_doc_vend.doc_vend_ln_no = po_doc_comm.doc_vend_ln_no)
		AND			(po_doc_hdr.doc_func_cd <> 3)
		AND			(po_doc_hdr.doc_phase_cd = 3)
		AND			(po_doc_comm.doc_cd = check_paydetail.rf_doc_cd(+))
		AND			(po_doc_comm.doc_id = check_paydetail.rf_doc_id(+))
		AND			(po_doc_comm.doc_dept_cd = check_paydetail.rf_doc_dept_cd(+))
		AND			(po_doc_comm.doc_comm_ln_no = check_paydetail.rf_doc_comm_ln_no(+))
		AND			(po_doc_comm.doc_vend_ln_no = check_paydetail.rf_doc_vend_ln_no(+))
		AND			(po_doc_hdr.doc_actu_am - po_doc_hdr.clsd_am) = 0

<cfif FORM.vencode NEQ ''>
		AND			po_doc_vend.vend_cust_cd = 	'#ucase(FORM.vencode)#'
</cfif>

<cfif FORM.potype NEQ 'ALL'>
		AND			po_doc_hdr.doc_cd = '#FORM.potype#'
</cfif>

<cfif FORM.dept NEQ ''>
		AND			po_doc_hdr.doc_dept_cd  = '#ucase(FORM.dept)#'
</cfif>

<cfif FORM.doc_id NEQ ''>
		AND			po_doc_hdr.doc_id = '#ucase(FORM.doc_id)#'
</cfif>

<cfif FORM.ma NEQ ''>
		AND			po_doc_hdr.agree_doc_id  = '#ucase(FORM.ma)#'
</cfif>

<cfif FORM.bfy NEQ ''>
		AND			po_doc_hdr.doc_bfy = #ucase(FORM.bfy)#
</cfif>

<cfif FORM.commdescription NEQ ''>
		AND			(((UPPER(po_doc_comm.comm_dscr) LIKE '%#ucase(FORM.commdescription)#%') OR
					(UPPER(po_doc_comm.cl_dscr_up) LIKE '%#ucase(FORM.commdescription)#%')) OR
					(UPPER(po_doc_comm.comm_cd) LIKE '%#ucase(FORM.commdescription)#%'))
</cfif>

<cfif FORM.fromdate NEQ ''>
		AND			po_doc_hdr.doc_rec_dt_dc between To_Date('#DateFormat(FORM.fromdate,"MM/DD/YYYY")#','mm/dd/yyyy')
		AND			to_date('#DateFormat(FORM.todate,"MM/DD/YYYY")#','mm/dd/yyyy')
</cfif>
)

		GROUP BY	po_doc_hdr.doc_cd,
					po_doc_hdr.doc_dept_cd,
					po_doc_hdr.doc_id,
					po_doc_vend.vend_cust_cd,
					po_doc_vend.LGL_NM,
					po_doc_hdr.doc_rec_dt_dc,
					po_doc_hdr.doc_clsd_dt,
					po_doc_hdr.agree_doc_cd,
					po_doc_hdr.agree_doc_dept_cd,
					po_doc_hdr.agree_doc_id,
					po_doc_hdr.doc_actu_am,
					po_doc_hdr.clsd_am,
					(po_doc_hdr.doc_actu_am - po_doc_hdr.clsd_am)

		ORDER BY	po_doc_hdr.doc_rec_dt_dc DESC
		</cfquery>

	<cfelseif FORM.status EQ 'ALL'>
		<cfquery name="po_query" datasource="fasdprod_fasdscan">
		SELECT		po_doc_hdr.doc_cd,
					po_doc_hdr.doc_dept_cd,
					po_doc_hdr.doc_id,
					po_doc_vend.vend_cust_cd,
					po_doc_vend.LGL_NM,
					po_doc_hdr.doc_rec_dt_dc,
					po_doc_hdr.doc_clsd_dt,
					po_doc_hdr.agree_doc_cd,
					po_doc_hdr.agree_doc_dept_cd,
					po_doc_hdr.agree_doc_id,
					po_doc_hdr.doc_actu_am,
					po_doc_hdr.clsd_am,
					- sum(check_paydetail.amount)as expended,
					(po_doc_hdr.doc_actu_am - po_doc_hdr.clsd_am) as outstandingamt

		FROM 		aims36.po_doc_hdr,
					aims36.po_doc_vend,
					aims36.po_doc_comm,
					aims36.check_paydetail


		WHERE		((po_doc_hdr.doc_cd = po_doc_vend.doc_cd)
		AND			(po_doc_hdr.doc_id = po_doc_vend.doc_id)
		AND			(po_doc_hdr.doc_dept_cd = po_doc_vend.doc_dept_cd)
		AND			(po_doc_hdr.doc_vers_no = po_doc_vend.doc_vers_no)
		AND			(po_doc_hdr.doc_phase_cd = po_doc_vend.doc_phase_cd)
		AND			(po_doc_vend.doc_cd = po_doc_comm.doc_cd)
		AND			(po_doc_vend.doc_id = po_doc_comm.doc_id)
		AND			(po_doc_vend.doc_dept_cd = po_doc_comm.doc_dept_cd)
		AND			(po_doc_vend.doc_vers_no = po_doc_comm.doc_vers_no)
		AND			(po_doc_vend.doc_phase_cd = po_doc_comm.doc_phase_cd)
		AND			(po_doc_vend.doc_vend_no = po_doc_comm.doc_vend_no)
		AND			(po_doc_vend.doc_vend_ln_no = po_doc_comm.doc_vend_ln_no)
		AND			(po_doc_hdr.doc_func_cd <> 3)
		AND			(po_doc_hdr.doc_phase_cd = 3)
		AND			(po_doc_comm.doc_cd = check_paydetail.rf_doc_cd(+))
		AND			(po_doc_comm.doc_id = check_paydetail.rf_doc_id(+))
		AND			(po_doc_comm.doc_dept_cd = check_paydetail.rf_doc_dept_cd(+))
		AND			(po_doc_comm.doc_comm_ln_no = check_paydetail.rf_doc_comm_ln_no(+))
		AND			(po_doc_comm.doc_vend_ln_no = check_paydetail.rf_doc_vend_ln_no(+))

<cfif FORM.vencode NEQ ''>
		AND			po_doc_vend.vend_cust_cd = 	'#ucase(FORM.vencode)#'
</cfif>

<cfif FORM.potype NEQ 'ALL'>
		AND			po_doc_hdr.doc_cd = '#FORM.potype#'
</cfif>

<cfif FORM.dept NEQ ''>
		AND			po_doc_hdr.doc_dept_cd  = '#ucase(FORM.dept)#'
</cfif>

<cfif FORM.doc_id NEQ ''>
		AND			po_doc_hdr.doc_id = '#ucase(FORM.doc_id)#'
</cfif>

<cfif FORM.ma NEQ ''>
		AND			po_doc_hdr.agree_doc_id  = '#ucase(FORM.ma)#'
</cfif>

<cfif FORM.bfy NEQ ''>
		AND			po_doc_hdr.doc_bfy = #ucase(FORM.bfy)#
</cfif>

<cfif FORM.commdescription NEQ ''>
		AND			(((UPPER(po_doc_comm.comm_dscr) LIKE '%#ucase(FORM.commdescription)#%') OR
					(UPPER(po_doc_comm.cl_dscr_up) LIKE '%#ucase(FORM.commdescription)#%')) OR
					(UPPER(po_doc_comm.comm_cd) LIKE '%#ucase(form.commdescription)#%'))
</cfif>

<cfif FORM.fromdate NEQ ''>
		AND			po_doc_hdr.doc_rec_dt_dc between To_Date('#DateFormat(FORM.fromdate,"MM/DD/YYYY")#','mm/dd/yyyy')
		AND			To_Date('#DateFormat(FORM.todate,"MM/DD/YYYY")#','mm/dd/yyyy')
</cfif>
)

		GROUP BY	po_doc_hdr.doc_cd,
					po_doc_hdr.doc_dept_cd,
					po_doc_hdr.doc_id,
					po_doc_vend.vend_cust_cd,
					po_doc_vend.LGL_NM,
					po_doc_hdr.doc_rec_dt_dc,
					po_doc_hdr.doc_clsd_dt,
					po_doc_hdr.agree_doc_cd,
					po_doc_hdr.agree_doc_dept_cd,
					po_doc_hdr.agree_doc_id,
					po_doc_hdr.doc_actu_am,
					po_doc_hdr.clsd_am,
					(po_doc_hdr.doc_actu_am - po_doc_hdr.clsd_am)

		ORDER BY	po_doc_hdr.doc_rec_dt_dc DESC
		</cfquery>
	</cfif>
</cfif>



<!---if vendor invoice is the only field entered return the next error message.--->
<cfif message3 is "cv">
	<cfoutput><h3>You have left all fields blank. Please enter a field.</h3></cfoutput>

<cfelseif message2 is "de">
	<cfoutput><h3>If you enter a date range, you must enter both the To and From fields. Select the Back on your browser and re-enter.</h3></cfoutput>

<cfelseif message6 is "cz">
	<cfoutput><h3>You cannot enter just dates.</h3></cfoutput>

<!---if the commodity description is not big enough--->
<cfelseif message7 is "ZZ">
	<cfoutput><h3>Enter more of the Commodity description.  You entered #form.commdescription#.</h3></cfoutput>

<!---if the record count is set to "E", then output message2.--->
<cfelseif po_query.recordcount is "E">
	<cfoutput><h3>#message2#</h3></cfoutput>

<!---Test to see if records were retrived, if not show message, else continue--->
<cfelseif po_query.recordcount is 0>
	<h3>Sorry, no records found.  Make sure you entered the information correctly.</h3>

<!---this is the first heading--->
<!---This will display the arrows pointing to the top, previous, next and bottom records including the record counts.  Also includes the "start at record" box--->
<!---what are the previous and next row to start positions.  This will initialize these variables--->
<cfelse>
	<cfoutput>
	<table align="RIGHT">
		<tr>
			<td>
				<a href="purchase_header_file.cfm?Purchase_file_header=Purhead.xls&amp;status=#URLEncodedFormat('#ucase(form.status)#')#&amp;potype=#URLEncodedFormat('#ucase(form.potype)#')#&amp;Vencode=#URLEncodedFormat('#ucase(form.vencode)#')#&amp;fromdate=#URLEncodedFormat('#DateFormat(form.fromdate,"MM/DD/YYYY")#')#&amp;todate=#URLEncodedFormat('#DateFormat(form.todate,"MM/DD/YYYY")#')#&amp;dept=#URLEncodedFormat('#ucase(form.dept)#')#&amp;commdescription=#URLEncodedFormat('#ucase(form.commdescription)#')#&amp;ma=#URLEncodedFormat('#ucase(form.ma)#')#&amp;doc_id=#URLEncodedFormat('#ucase(form.doc_id)#')#&amp;bfy=#URLEncodedFormat('#form.bfy#')#" title="Select to download Purchase Order detail to a file">
					<font>Dowload Header Information To Excel</font>
				</a>
			</td>
		</tr>
		<tr>
			<td>
				<a href="purchase_acct_file.cfm?Purchase_file_name=Puracct.xls&amp;status=#URLEncodedFormat('#ucase(form.status)#')#&amp;potype=#URLEncodedFormat('#ucase(form.potype)#')#&amp;Vencode=#URLEncodedFormat('#ucase(form.vencode)#')#&amp;fromdate=#URLEncodedFormat('#DateFormat(form.fromdate,"MM/DD/YYYY")#')#&amp;todate=#URLEncodedFormat('#DateFormat(form.todate,"MM/DD/YYYY")#')#&amp;dept=#URLEncodedFormat('#ucase(form.dept)#')#&amp;ma=#URLEncodedFormat('#ucase(form.ma)#')#&amp;commdescription=#URLEncodedFormat('#ucase(form.commdescription)#')#&amp;doc_id=#URLEncodedFormat('#ucase(form.doc_id)#')#&amp;bfy=#URLEncodedFormat('#form.bfy#')#" title="Select to download Purchase Order detail to a file">
					<font>Download Commodity/Accounting Information To Excel</font>
				</a>
			</td>
		</tr>
	</table>
	</cfoutput>

	<cfset userstart = start>
	<cfif userstart lt 1>
		<cfset start = 1>
	</cfif>
	<cfset maxrows=50>
	<cfset firstrecord = 1>
	<cfset lastrecord = po_query.recordcount>
	<cfset prevstart = start - maxrows>
	<cfset nextstart = start + maxrows>
	<cfset currentrow = start>
	<cfset throughrow = start + maxrows - 1>
	<cfset userstart = start>
<!--- 
	<table class="table table-bordered table-striped table-condensed">
		<thead>
			<tr>
				<th>Dept Code</th>
				<th>Department Name</th>
			</tr>
		</thead>
		<tbody>
			
			<tr>
				<td width="10%" align="center">1500</td>
				<td align="left">AUSTIN RESOURCE RECOVERY</td>
			</tr>
			
			<tr>
				<td width="10%" align="center">1507</td>
				<td align="left">AUSTIN RESOURCE RECOVERY CIPS</td>
			</tr>
			
			<tr>
				<td width="10%" align="center">250</td>
				<td align="left">TRANSPORTATION, PLAN &amp; SUSTAIN</td>
			</tr>
			
			<tr>
				<td width="10%" align="center">2507</td>
				<td align="left">PW-MOBILITY CIPS</td>
			</tr>
			
			<tr>
				<td width="10%" align="center">3500</td>
				<td align="left">G O DEBT SERVICE</td>
			</tr>
			
			<tr>
				<td width="10%" align="center">4500</td>
				<td align="left">OFFICE OF THE CITY CLERK</td>
			</tr>
			
			<tr>
				<td width="10%" align="center">5000</td>
				<td align="left">NONDEPARTMENTAL REVENUE/EXPENSES</td>
			</tr>
			
			<tr>
				<td width="10%" align="center">530</td>
				<td align="left">DEVELOPMENT REVIEW &amp; INSPECTN</td>
			</tr>
			
			<tr>
				<td width="10%" align="center">5500</td>
				<td align="left">ECONOMIC DEVELOPMENT</td>
			</tr>
			
			<tr>
				<td width="10%" align="center">5507</td>
				<td align="left">ECONOMIC DEVELOPMENT CIPS</td>
			</tr>
			
			<tr>
				<td width="10%" align="center">5600</td>
				<td align="left">COMMUNICATIONS AND TECHNOLOGY MANAGEMENT</td>
			</tr>
			
			<tr>
				<td width="10%" align="center">5607</td>
				<td align="left">CTM CIPS</td>
			</tr>
			
			<tr>
				<td width="10%" align="center">5700</td>
				<td align="left">LAW</td>
			</tr>
			
			<tr>
				<td width="10%" align="center">5707</td>
				<td align="left">LAW CIPS</td>
			</tr>
			
			<tr>
				<td width="10%" align="center">5800</td>
				<td align="left">HUMAN RESOURCES</td>
			</tr>
			
			<tr>
				<td width="10%" align="center">5900</td>
				<td align="left">COMMUNICATIONS AND PUBLIC INFORMMATION</td>
			</tr>
			
			<tr>
				<td width="10%" align="center">6500</td>
				<td align="left">CONTRACT MANAGEMENT</td>
			</tr>
			
			<tr>
				<td width="10%" align="center">7500</td>
				<td align="left">BUILDING SERVICES</td>
			</tr>
			
			<tr>
				<td width="10%" align="center">7507</td>
				<td align="left">BUILDING SERVICES CIP</td>
			</tr>
			
			<tr>
				<td width="10%" align="center">8500</td>
				<td align="left">AUSTIN PUBLIC LIBRARY</td>
			</tr>
			
			<tr>
				<td width="10%" align="center">8507</td>
				<td align="left">LIBRARY CIPS</td>
			</tr>
			
			<tr>
				<td width="10%" align="center">9500</td>
				<td align="left">COMMUNITY CARE</td>
			</tr>
			
			<tr>
				<td width="10%" align="center">9507</td>
				<td align="left">COMMUNITY CARE CIPS</td>
			</tr>
			
		</tbody>
		</table>
	 --->	
			<!---first record button code--->
<table>
   <tr>			
			<cfif start gt 1 >
				<cfoutput>
				<form action="po_action.cfm" method="post">
					<input type="hidden" name="start" value="#firstrecord#">
					<input type="hidden" name="vencode" value="#vencode#">
					<input type="hidden" name="dept" value="#dept#">
					<input type="hidden" name="commdescription" value="#commdescription#">
					<input type="hidden" name="doc_id" value="#doc_id#">
					<input type="hidden" name="status" value="#status#">
					<input type="hidden" name="fromdate" value="#fromdate#">
					<input type="hidden" name="todate" value="#todate#">
					<input type="hidden" name="potype" value="#potype#">
					<input type="hidden" name="ma" value="#ma#">
					<input type="hidden" name="bfy" value="#bfy#">
					<button class="btn btn-primary ttip_t" type="submit" title="First Page"><i class="splashy-arrow_large_left"></i></button>
					<!--- <input type="submit" class="btn btn-sm" value="<<1First"> --->
					
				</form>
				</cfoutput>
			<cfelse>
				<cfoutput>
				<!---show top button disabled--->
				
				<button class="btn btn-primary ttip_t" type="submit" title="First Page"><i class="splashy-arrow_large_left_outline"></i></button>
				<!--- <input type="submit" class="btn btn-sm" value="2First">	 --->			
				 
				</cfoutput>
			</cfif>
			</td>

			<!---previous button code--->
			<!---If the prevstart is greater or equal to 1, then there are previous records to be displayed therefore execute the following--->
			<!--- <td> --->
			<cfif prevstart gte 1>
				<cfoutput>
				<form action="po_action.cfm" method="post">
					<input type="hidden" name="start" value="#prevstart#">
					<input type="hidden" name="vencode" value="#vencode#">
					<input type="hidden" name="dept" value="#dept#">
					<input type="hidden" name="commdescription" value="#commdescription#">
					<input type="hidden" name="doc_id" value="#doc_id#">
					<input type="hidden" name="fromdate" value="#fromdate#">
					<input type="hidden" name="todate" value="#todate#">
					<input type="hidden" name="status" value="#status#">
					<input type="hidden" name="potype" value="#potype#">
					<input type="hidden" name="ma" value="#ma#">
					<input type="hidden" name="bfy" value="#bfy#">
					<button class="btn btn-primary ttip_t" type="submit" title="Previous Page"><i class="splashy-arrow_large_left"></i></i></button>
					
					
					
				</form>
				</cfoutput>

			<!---If the first else fails, this will check to see if the start is greater then  1 but less then maxrows--->
			<cfelseif start gt 1>
				<cfoutput>
				<form action="po_action.cfm" method="post">
					<input type="hidden" name="start" value="#firstrecord#">
					<input type="hidden" name="vencode" value="#vencode#">
					<input type="hidden" name="dept" value="#dept#">
					<input type="hidden" name="commdescription" value="#commdescription#">
					<input type="hidden" name="doc_id" value="#doc_id#">
					<input type="hidden" name="fromdate" value="#fromdate#">
					<input type="hidden" name="todate" value="#todate#">
					<input type="hidden" name="status" value="#status#">
					<input type="hidden" name="potype" value="#potype#">
					<input type="hidden" name="ma" value="#ma#">
					<input type="hidden" name="bfy" value="#bfy#">
					<button class="btn btn-primary ttip_t" type="submit" title="Previous Page"><i class="splashy-arrow_large_left"></i></i></button>
					<!--- <input type="submit" class="btn btn-sm" value="<4Previous"> --->
					
					
					
				</form>
				</cfoutput>

			<!---If there are no previous records, then show disable button--->
			<cfelse>
				<cfoutput>
				<button class="btn btn-primary ttip_t" type="submit" title="Previous Page"><i class="splashy-arrow_large_left_outline"></i></button>
				
				
				</cfoutput>
			</cfif>
			<!---  </td>  --->

			<!---The following will show  1 - 10 of 12 as an example--->
			<cfoutput>
			#currentrow#
			-
			<!---IF the throughrow (start + maxrow - 1) is greater then record count, then display the record count only--->
			<cfif throughrow gt po_query.recordcount>
				#po_query.recordcount# 
			<cfelse>
				#throughrow#
			</cfif>
			of 
			#po_query.recordcount#
			</cfoutput>
			<!---next button code--->
		<cfif nextstart lte po_query.recordcount>
					<cfoutput>
						<form action="po_action.cfm" method="POST">
						<button class="btn btn-primary ttip_t" type="submit" title="Next Page"><i class="splashy-arrow_large_right"></i></button>
						<!--- <input type="submit" class="btn btn-sm" value=">6Next"> --->
						<input type="hidden" name="start" value="#nextstart#">
						<input type="hidden" name="vencode" value="#vencode#">
						<input type="hidden" name="dept" value="#dept#">
						<input type="hidden" name="commdescription" value="#commdescription#">
						<input type="hidden" name="doc_id" value="#doc_id#">
						<input type="hidden" name="fromdate" value="#fromdate#">
						<input type="hidden" name="todate" value="#todate#">
						<input type="hidden" name="status" value="#status#">
						<input type="hidden" name="potype" value="#potype#">
						<input type="hidden" name="ma" value="#ma#">
						<input type="hidden" name="bfy" value="#bfy#">
												</form>
					</cfoutput>
				 <cfelse> 
					<!--- <input type="submit" class="btn btn-sm" value="8Last6"> --->
			</cfif>

			<!---last record button code--->
			
				<cfif nextstart lte po_query.recordcount>
					<cfoutput>
					<form action="po_action.cfm" method="POST">
						<input type="hidden" name="start" value="#lastrecord#">
						<input type="hidden" name="vencode" value="#vencode#">
						<input type="hidden" name="dept" value="#dept#">
						<input type="hidden" name="commdescription" value="#commdescription#">
						<input type="hidden" name="doc_id" value="#doc_id#">
						<input type="hidden" name="fromdate" value="#fromdate#">
						<input type="hidden" name="todate" value="#todate#">
						<input type="hidden" name="status" value="#status#">
						<input type="hidden" name="potype" value="#potype#">
						<input type="hidden" name="ma" value="#ma#">
						<input type="hidden" name="bfy" value="#bfy#">
						<button class="btn btn-primary ttip_t" type="submit" title="Last Page"><i class="splashy-arrow_large_right"></i></button>
						
					</form>
					</cfoutput>
				<cfelse>
					<cfoutput>
					<!---Bottom disabled button code--->
				<button class="btn btn-primary ttip_t" type="submit" title="Last Page"><i class="splashy-arrow_large_right_outline"></i></button>
				
				
					
					
					</cfoutput>
				</cfif>
			
</tr>

		<!---This is where the "get record xxx" starts--->
			
		
				<cfoutput>
				<form action="po_action.cfm" method="post">
					<input type="Text" name="start" value="#userstart#" size="4" maxlength="4">
					<input class="btn btn-primary" type="submit" value="Get Record" onClick="this.form.submit();this.disabled='true';this.value='Please wait for the record to be retrieved';">
					<input type="hidden" name="vencode" value="#vencode#">
					<input type="hidden" name="dept" value="#dept#">
					<input type="hidden" name="commdescription" value="#commdescription#">
					<input type="hidden" name="doc_id" value="#doc_id#">
					<input type="hidden" name="fromdate" value="#fromdate#">
					<input type="hidden" name="todate" value="#todate#">
					<input type="hidden" name="status" value="#status#">
					<input type="hidden" name="potype" value="#potype#">
					<input type="hidden" name="ma" value="#ma#">
					<input type="hidden" name="bfy" value="#bfy#">
				</form>
				</cfoutput>
			</table>

<!---this is where the detail for the Check number, Date and Amount will output--->
	<table class="table table-bordered table-striped table-condensed">
		<tr>
			<th>Vendor CD</TH>
			<th>Order</TH>
			<th>PO Date</TH>
			<th>Vendor Name</TH>
			<th>Original AMT</TH>
			<th>Expended AMT</TH>
			<th>Closed AMT</th>
			<th>Outstanding AMT</th>
		</tr>

		<cfoutput query="po_query" startrow=#start# maxrows=#maxrows#>
		<tr>
			<td>#vend_cust_cd#&nbsp </td>
			<td><a href="po_detail.cfm?transcode=#URLEncodedFormat(doc_cd)#&amp;doc_dept_cd=#URLEncodedFormat(doc_dept_cd)#&amp;ponumber=#URLEncodedFormat(doc_id)#" title ="Click for Purchase Order Details">#doc_cd#-#doc_dept_cd#-#doc_id#&nbsp</a> </td>
			<td>#DateFormat(doc_rec_dt_dc,"mm/dd/yyyy")#&nbsp</td>
			<td>#LGL_NM#&nbsp </td>
			<td>#DollarFormat(doc_actu_am)#</td>
			<td>#DollarFormat(expended)#</td>
			<td>#DollarFormat(clsd_am)#</td>
			<td>#DollarFormat(outstandingamt)#</td>
		</tr>
		</cfoutput>
	</table>
</cfif>