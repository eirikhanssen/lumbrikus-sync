<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step name="sync" xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0">
    <p:serialization port="result" omit-xml-declaration="true" indent="false" method="text"></p:serialization>
    <p:input port="source"/>
    <p:output port="result">
    </p:output>
    
    <p:filter name="filter_norwegian" select="article[@lang='no']"></p:filter>
    
    <p:identity name="final"/>
    
    <!-- 
    
    calabash -i source=in.html filter.xpl 
    
    -->
</p:declare-step>