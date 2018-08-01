<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step name="sync" xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0">
    <p:serialization port="result" omit-xml-declaration="true" indent="false" method="text"></p:serialization>
    <p:input port="source"/>
    <p:output port="result">
    </p:output>
    <p:namespace-rename from="http://www.w3.org/ns/ttml" to=""/>
    <p:xslt name="xslt-prepare-for-grouping" version="2.0">
        <p:input port="source"/>
        <p:input port="parameters"><p:empty/></p:input>
        <p:input port="stylesheet">
            <p:inline>
                <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                    xmlns:xs="http://www.w3.org/2001/XMLSchema"      
                    exclude-result-prefixes="xs"
                    version="2.0">
                    <xsl:output method="text" omit-xml-declaration="yes"></xsl:output>
                    <xsl:strip-space elements="*"/>
                    <xsl:template match="audio"/>
                     
                     <xsl:template match="div"><xsl:apply-templates/></xsl:template>
                     
                     <xsl:template match="div[@class='key']"><xsl:text>&#xa;#</xsl:text><xsl:apply-templates/></xsl:template>
                    
                      <xsl:template match="p">
                          <xsl:value-of select="."/><xsl:text>&#xa;</xsl:text>
                      </xsl:template>
                     
                    <xsl:template match="@*|node()">
                        <xsl:copy>
                            <xsl:apply-templates select="@*|node()"/>
                        </xsl:copy>
                    </xsl:template>
                </xsl:stylesheet>
            </p:inline>
        </p:input>
    </p:xslt>
    
    
    <p:identity name="final"/>
    
    <!-- 
    
    calabash -i source=in.html prep2sync-kort.xpl 
    
    -->
</p:declare-step>