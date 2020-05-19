<cfcomponent output="false">
	<cfset this.name="DECOCONSENT">
	<cfset this.setDomainCookies = true>
	<cfset this.sessionManagement = false>
	<cfset this.clientManagement = false>
	<cfset this.timezone = ''>

	<cffunction name="onRequestStart" output="false" returntype="boolean">
		<cfreturn true>
	</cffunction>

	<cffunction name="onRequestEnd" output="false" returntype="boolean">
		<cfreturn true>
	</cffunction>
</cfcomponent>
