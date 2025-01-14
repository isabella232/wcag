<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:html="http://www.w3.org/1999/xhtml"
	xmlns:wcag="https://www.w3.org/WAI/GL/"
	exclude-result-prefixes="#all"
	version="2.0">
	
	<xsl:include href="base.xslt"/>
	
	<xsl:output method="xml" indent="yes"/>
	
	<xsl:template name="id">
		<xsl:attribute name="id">
			<xsl:choose>
				<xsl:when test="@id"><xsl:value-of select="@id"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="wcag:generate-id(wcag:find-heading(.))"/></xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	</xsl:template>
	
	<xsl:template name="content">
		<content><xsl:copy-of select="*[not(name() = 'h1' or name() = 'h2' or name() = 'h3' or name() = 'h4' or name() = 'h5' or name() = 'h6' or name() = 'section' or @class = 'conformance-level' or @class = 'change')]"></xsl:copy-of></content>
	</xsl:template>
	
	<xsl:template match="html:html">
		<guidelines lang="{@lang}">
			<understanding>
				<name>Introduction to Understanding WCAG 2.1</name>
				<file href="intro"/>
			</understanding>
			<understanding>
				<name>Understanding Techniques for WCAG Success Criteria</name>
				<file href="understanding-techniques"/>
			</understanding>
			<understanding>
				<name>Understanding Test Rules for WCAG Success Criteria</name>
				<file href="understanding-act-rules"/>
			</understanding>
			<xsl:apply-templates select="//html:section[@class='principle']"/>
			<understanding>
				<name>Understanding Conformance</name>
				<file href="conformance"/>
			</understanding>
			<understanding>
				<name>How to Refer to WCAG 2.1 from Other Documents</name>
				<file href="refer-to-wcag"/>
			</understanding>
			<understanding>
				<name>Documenting Accessibility Support for Uses of a Web Technology</name>
				<file href="documenting-accessibility-support"/>
			</understanding>
			<understanding>
				<name>Understanding Metadata</name>
				<file href="understanding-metadata"/>
			</understanding>
			<xsl:apply-templates select="//html:dfn"/>
		</guidelines>
	</xsl:template>
	
	<xsl:template match="html:section[@class='principle']">
		<principle>
			<xsl:call-template name="id"/>
			<version>WCAG20</version>
			<num><xsl:number count="html:section[@class='principle']" format="1"/></num>
			<name><xsl:value-of select="wcag:find-heading(.)"/></name>
			<xsl:call-template name="content"/>
			<xsl:apply-templates select="html:section"/>
		</principle>
	</xsl:template>
	
	<xsl:template match="html:section[contains(@class, 'guideline')]">
		<guideline>
			<xsl:call-template name="id"/>
			<num><xsl:number level="multiple" count="html:section[contains(@class, 'principle')]|html:section[contains(@class, 'guideline')]" format="1.1"/></num>
			<name><xsl:value-of select="wcag:find-heading(.)"/></name>
			<xsl:call-template name="content"/>
			<file href="{wcag:generate-id(wcag:find-heading(.))}"/>
			<xsl:apply-templates select="html:section"/>
		</guideline>
	</xsl:template>
	
	<xsl:template match="html:section[contains(@class, 'sc')]">
		<success-criterion>
			<xsl:call-template name="id"/>
			<num><xsl:number level="multiple" count="html:section[contains(@class, 'principle')]|html:section[contains(@class, 'guideline')]|html:section[contains(@class, 'sc')]" format="1.1.1"/></num>
			<name><xsl:value-of select="wcag:find-heading(.)"/></name>
			<xsl:call-template name="content"/>
			<level><xsl:value-of select="html:p[@class='conformance-level']"/></level>
			<file href="{wcag:generate-id(wcag:find-heading(.))}"/>
		</success-criterion>
	</xsl:template>
	
	<xsl:template match="html:dfn">
		<xsl:variable name="alts" select="tokenize(@data-lt, '\|')"></xsl:variable>
		<term>
			<id><xsl:text>dfn-</xsl:text><xsl:value-of select="wcag:generate-id(.)"/></id>
			<name><xsl:value-of select="lower-case(.)"/></name>
			<xsl:for-each select="$alts">
				<name><xsl:value-of select="lower-case(.)"/></name>
			</xsl:for-each>
			<definition>
				<xsl:copy-of select="../following-sibling::html:dd[1]/node()"/>
			</definition>
		</term>
	</xsl:template>
	
</xsl:stylesheet>
