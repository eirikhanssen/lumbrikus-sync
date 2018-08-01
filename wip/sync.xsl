<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tt="http://www.w3.org/ns/ttml"
    xmlns:eh="http://eirikhanssen.com/ns"
    exclude-result-prefixes="xs tt eh"
    version="2.0">
    <xsl:output method="xml" omit-xml-declaration="yes"></xsl:output>
    <xsl:function name="eh:timer" as="xs:string">
        <xsl:param name="input" as="xs:string"></xsl:param>
        <xsl:variable name="fraction" select="replace($input, '^[0-9]+([.][0-9]+)s$','$1')"/>
        <xsl:variable name="whole_seconds" select="xs:integer(replace($input, '^([0-9]+)([.][0-9]+)s$','$1'))"/>
        <xsl:variable name="duration" select="$whole_seconds * xs:dayTimeDuration('PT1S')"/>
        <xsl:variable name="minutes" select="minutes-from-duration($duration)"/>
        <xsl:variable name="seconds" select="seconds-from-duration($duration)"/>
        <xsl:value-of select="concat(format-number($minutes,'00'), ':' , format-number($seconds, '00'), $fraction)"/>
    </xsl:function>
    
    <xsl:template match="processing-instruction('k')"><k/></xsl:template>
    
    <xsl:template match="tt:tt|tt:body|tt:div">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="/">
        <div class="cues"><xsl:apply-templates/></div>
    </xsl:template>
    
    <xsl:template match="tt:p">
        <p><xsl:element name="span">
            <xsl:attribute name="data-begin" select="eh:timer(@begin)"/>
            <xsl:attribute name="data-end" select="eh:timer(@end)"/>
            <xsl:value-of select="."/>
        </xsl:element></p>
    </xsl:template>
    
</xsl:stylesheet>