<?xml version="1.0" encoding="UTF-8"?>
<!--
Licensed to the Apache Software Foundation (ASF) under one or more
contributor license agreements.  See the NOTICE file distributed with
this work for additional information regarding copyright ownership.
The ASF licenses this file to you under the Apache License,
Version 2.0 (the "License"); you may not use this file except in
compliance with the License.  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <!-- Import parent stylesheet -->
    <xsl:import href="common.xsl"/>

    <xsl:template name="content">
        <xsl:comment>NOTE: Syntax highlighting script is LGPL</xsl:comment>
        <script xmlns="" type="text/javascript" src="http://alexgorbatchev.com/pub/sh/current/scripts/shCore.js"/>
        <script xmlns="" type="text/javascript" src="http://alexgorbatchev.com/pub/sh/current/scripts/shBrushJava.js"/>
        <script xmlns="" type="text/javascript" src="http://alexgorbatchev.com/pub/sh/current/scripts/shBrushXml.js"/>
        <script xmlns="" type="text/javascript" src="http://alexgorbatchev.com/pub/sh/current/scripts/shBrushJScript.js"/>
        <link type="text/css" rel="stylesheet" href="http://alexgorbatchev.com/pub/sh/current/styles/shCore.css"/>
        <link type="text/css" rel="stylesheet" href="http://alexgorbatchev.com/pub/sh/current/styles/shThemeDefault.css"/>
        <script type="text/javascript">
            SyntaxHighlighter.all();
        </script>

        <xsl:apply-templates/>

        <xsl:variable name="index" select="document(concat($trunk, '/tutorials/www/index.xml'))/document"/>
        <xsl:variable name="id" select="/document/@id"/>
        <xsl:variable name="index-node" select="$index//document-item[@id=$id]"/>

        <xsl:variable name="next-id">
            <xsl:choose>
                <xsl:when test="$index-node/document-item">
                    <xsl:value-of select="$index-node/document-item/@id"/>
                </xsl:when>
                <xsl:when test="$index-node/following::document-item">
                    <xsl:value-of select="$index-node/following::document-item/@id"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>

        <xsl:if test="string-length($next-id)!=0">
            <p>
                <xsl:text>Next: </xsl:text>
                <a href="{$next-id}.html">
                    <xsl:variable name="tutorial" select="document(concat($trunk, '/tutorials/www/', $next-id, '.xml'))/document"/>
                    <xsl:value-of select="$tutorial/properties/title"/>
                </a>
            </p>
        </xsl:if>
    </xsl:template>

    <!-- <source> gets translated to pre-formatted source code block -->
    <xsl:template match="source">
        <xsl:element name="pre">
            <xsl:attribute name="class">
                <xsl:choose>
                    <xsl:when test="@type">
                        <xsl:text>brush:</xsl:text>
                        <xsl:value-of select="@type"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>brush</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:if test="@line-numbers='false'">
                    <xsl:text>;gutter:false</xsl:text>
                </xsl:if>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>
