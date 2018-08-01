<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step name="sync" xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0">
    <p:serialization port="result" omit-xml-declaration="true" indent="false" method="text"></p:serialization>
    <p:input port="source"/>
    <p:output port="result">
    </p:output>
     
    <p:xslt name="xslt-text" version="2.0">
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
                    
                    <xsl:template match="p"><xsl:text>¶$</xsl:text><xsl:analyze-string select="." regex="([.?!:]\s+)(\S)">
                        <xsl:matching-substring><xsl:value-of select="regex-group(1)"/><xsl:text>&#xa;$</xsl:text><xsl:value-of select="regex-group(2)"/></xsl:matching-substring>
                        <xsl:non-matching-substring><xsl:value-of select="."/></xsl:non-matching-substring>
                    </xsl:analyze-string><xsl:text>&#xa;</xsl:text>
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
    
    calabash -i source=in.html prep2sync-lang.xpl 
    
    -->
</p:declare-step>