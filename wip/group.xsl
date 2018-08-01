<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output method="xml" indent="yes"></xsl:output>
    <xsl:template match="div[@class='cues']">
        <div class="cues">
            <xsl:variable name="groups">
            <xsl:for-each-group select="*" group-starting-with="k" >
                <xsl:element name="div">
                    <xsl:attribute name="class" select="'key'"/>
                    <xsl:attribute name="data-key" select="count(preceding::k)+1"></xsl:attribute>
                    <xsl:for-each select="current-group()">
                        <xsl:copy>
                            <xsl:apply-templates/>
                        </xsl:copy>
                    </xsl:for-each>
                </xsl:element>
            </xsl:for-each-group>
            </xsl:variable>
            <xsl:sequence select="$groups/div">
            </xsl:sequence>
        </div>
    </xsl:template>
    
    <xsl:template match="k"/>
    
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>