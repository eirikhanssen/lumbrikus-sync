<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step name="sync" xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0">
    <p:serialization port="result" omit-xml-declaration="true" indent="true" method="xml"></p:serialization>
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
                    xmlns:c="http://www.w3.org/ns/xproc-step"
                    xmlns:eh="http://eirikhanssen.com/ns"
                    exclude-result-prefixes="xs eh c"
                    version="2.0">
                    <xsl:output method="xml" omit-xml-declaration="yes"></xsl:output>

                    <xsl:template match="/">
                        <div class="cues"><xsl:apply-templates/></div>
                    </xsl:template>

                    <xsl:template match="p">
                        <xsl:variable name="this" select="."/>
                        <xsl:analyze-string select="." regex="[#]">
                            <xsl:matching-substring><key_begin/></xsl:matching-substring>
                            <xsl:non-matching-substring>
                                <xsl:analyze-string select="." regex="[¶]">
                                    <xsl:matching-substring><para_begin/></xsl:matching-substring>
                                    <xsl:non-matching-substring>
                                        <xsl:analyze-string select="." regex="[$]">
                                            <xsl:matching-substring/>
                                            <xsl:non-matching-substring>
                                                <xsl:element name="span">
                                                    <xsl:copy-of select="$this/@*"></xsl:copy-of>
                                                    <xsl:value-of select="."/>
                                                </xsl:element>
                                            </xsl:non-matching-substring>
                                        </xsl:analyze-string>
                                    </xsl:non-matching-substring>
                                </xsl:analyze-string>
                            </xsl:non-matching-substring>
                        </xsl:analyze-string>
                    </xsl:template>
                    
                    <xsl:template match="tt|body|div">
                        <xsl:apply-templates/>
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
    
    <p:xslt name="xslt-group-by-keys" version="2.0">
        <p:input port="source"/>
        <p:input port="parameters"><p:empty/></p:input>
        <p:input port="stylesheet">
            <p:inline>
                <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                    xmlns:xs="http://www.w3.org/2001/XMLSchema"
                    exclude-result-prefixes="xs"
                    version="2.0">
                    <xsl:output method="xml" indent="yes"></xsl:output>
                    <xsl:template match="div[@class='cues']">
                        <div class="cues">
                            <xsl:variable name="groups">
                                <xsl:for-each-group select="*" group-starting-with="key_begin" >
                                    <xsl:element name="div">
                                        <xsl:attribute name="class" select="'key'"/>
                                        <xsl:attribute name="data-key" select="count(preceding::key_begin)+1"></xsl:attribute>
                                        <xsl:for-each select="current-group()">
                                            <xsl:copy>
                                                <xsl:copy-of select="@*|node()"/>
                                            </xsl:copy>
                                        </xsl:for-each>
                                    </xsl:element>
                                </xsl:for-each-group>
                            </xsl:variable>
                            <xsl:sequence select="$groups/div">
                            </xsl:sequence>
                        </div>
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
    <p:delete name="delete-key_begin" match="key_begin"/>
    
    <p:xslt name="xslt-group-by-paras" version="2.0">
        <p:input port="source"/>
        <p:input port="parameters"><p:empty/></p:input>
        <p:input port="stylesheet">
            <p:inline>
                <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                    xmlns:xs="http://www.w3.org/2001/XMLSchema"
                    exclude-result-prefixes="xs"
                    version="2.0">
                    <xsl:output method="xml" indent="yes"></xsl:output>
                    <xsl:template match="div[@class='key']">
                        <div class="cues">
                            <xsl:variable name="groups">
                                <xsl:for-each-group select="node()|@*" group-starting-with="para_begin" >
                                    <xsl:element name="p">
                                        <xsl:for-each select="current-group()">
                                            <xsl:copy>
                                                <xsl:copy-of select="@*|node()"/>
                                            </xsl:copy>
                                        </xsl:for-each>
                                    </xsl:element>
                                </xsl:for-each-group>
                            </xsl:variable>
                            <xsl:sequence select="$groups/node()|@*"/>
                        </div>
                    </xsl:template>
                    
                    <xsl:template match="span">
                        <span_copy><xsl:copy-of select="@*|node()"></xsl:copy-of></span_copy>
                        
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
    <p:delete name="delete-para_begin" match="para_begin"/>
    
    <p:namespace-rename from="http://www.w3.org/ns/xproc-step" to=""></p:namespace-rename>
    <p:identity name="final"/>
    
    <!-- 
    
    calabash -i source=in.ttml sync2html-kort.xpl > out.html 
    
    -->
</p:declare-step>