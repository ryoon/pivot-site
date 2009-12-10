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
    <xsl:import href="project.xsl"/>

    <!-- Output method is HTML -->
    <xsl:output method="html" encoding="UTF-8" indent="no"
        doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
        doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/>

    <!-- Absolute URL (not fully qualified) to the project root -->
    <xsl:variable name="root">
        <xsl:value-of select="$project/@href"/>
        <!--
        <xsl:variable name="tmp" select="substring-after($project/@href, 'http://')"/>
        <xsl:text>/</xsl:text>
        <xsl:value-of select="substring-after($tmp, '/')"/>
        -->
    </xsl:variable>

    <!-- <document> translates to an HTML page -->
    <xsl:template match="document">
        <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>

                <!-- Page title -->
                <title>
                    <xsl:if test="properties/title">
                        <xsl:value-of select="properties/title"/>
                        <xsl:text> | </xsl:text>
                    </xsl:if>
                    <xsl:value-of select="$project/title"/>
                </title>

                <!-- CSS styles -->
                <xsl:call-template name="css"/>

                <!-- Apply document head -->
                <xsl:apply-templates select="head" mode="value"/>

                <!-- Google analytics -->
                <script type="text/javascript">
                    var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
                    document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
                </script>
                <script type="text/javascript">
                    try {
                        var pageTracker = _gat._getTracker("UA-7977275-1");
                        pageTracker._trackPageview();
                    } catch(err) {}
                </script>
            </head>

            <body>
                <xsl:apply-templates select="body" mode="value"/>
            </body>
        </html>
    </xsl:template>

    <!-- <body> content gets wrapped within the site header, left navigation, and footer -->
    <xsl:template match="body" mode="value">
        <div id="wrapper">
            <div id="main">
                <div id="header">
                    <!-- Logo -->
                    <xsl:element name="div">
                        <xsl:attribute name="class">
                            <xsl:choose>
                                <xsl:when test="boolean(/document/properties/home)">logoHome</xsl:when>
                                <xsl:otherwise>logo</xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                        <a href="{$root}index.html">
                            <img src="{$root}images/logo.png" alt="{$project/title}"
                                title="{$project/title} Homepage"/>
                        </a>
                    </xsl:element>

                    <!-- Tagline -->
                    <div class="tagline">
                        <img src="{$root}images/tagline.png" alt="{$project/tagline}"/>
                    </div>

                    <!-- Global navigation -->
                    <ul class="navi">
                        <xsl:for-each select="$project/document-groups/document-group[@href]">
                            <li>
                                <xsl:element name="a">
                                    <xsl:attribute name="href">
                                        <xsl:variable name="location">
                                            <xsl:apply-templates select="@href" mode="value"/>
                                        </xsl:variable>
                                        <xsl:if test="not(starts-with($location, 'http://'))">
                                            <xsl:value-of select="$root"/>
                                        </xsl:if>
                                        <xsl:value-of select="$location"/>
                                    </xsl:attribute>
                                    <xsl:apply-templates select="title" mode="value"/>
                                </xsl:element>
                            </li>
                        </xsl:for-each>
                    </ul>
                </div>

                <!-- Content envelope -->
                <xsl:call-template name="envelope"/>
            </div>

            <div id="footer" class="group">
                <!-- Footer logo -->
                <div class="footerLogo">
                    <xsl:for-each select="$project/copyright/message">
                        <xsl:if test="position()&gt;1"><br/></xsl:if>
                        <xsl:value-of select="."/>
                    </xsl:for-each>
                </div>

                <!-- Footer links -->
                <div class="footerLinks">
                    <ul class="footerMenuGr">
                        <xsl:for-each select="$project/document-groups/document-group[not(@footer='false')]">
                            <li>
                                <strong>
                                    <xsl:apply-templates select="title" mode="value"/>
                                </strong>
                                <ul>
                                    <xsl:if test="@id='demos'">
                                        <xsl:for-each select="$project/footer-demos/demo">
                                            <xsl:variable name="id" select="@id"/>
                                            <li>
                                                <xsl:element name="a">
                                                    <xsl:choose>
                                                        <xsl:when test="$project/external-demos/demo[@id=$id]">
                                                            <xsl:variable name="demo" select="$project/external-demos/demo[@id=$id]"/>
                                                            <xsl:attribute name="href">
                                                                <xsl:value-of select="$demo/@href"/>
                                                            </xsl:attribute>
                                                            <xsl:attribute name="target">_new</xsl:attribute>
                                                            <xsl:apply-templates select="$demo/properties/title" mode="value"/>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:variable name="document" select="document(concat($trunk, '/demos/www/', $id, '.xml'))/document"/>
                                                            <xsl:attribute name="href">
                                                                <xsl:value-of select="concat($root, 'demos/', @id, '.html')"/>
                                                            </xsl:attribute>
                                                            <xsl:if test="boolean($document/properties/full-screen)">
                                                                <xsl:attribute name="target">_new</xsl:attribute>
                                                            </xsl:if>
                                                            <xsl:apply-templates select="$document/properties/title" mode="value"/>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:element>
                                            </li>
                                        </xsl:for-each>
                                    </xsl:if>

                                    <xsl:for-each select="documents/document[not(@footer='false')]">
                                        <li>
                                            <xsl:element name="a">
                                                <xsl:attribute name="href">
                                                    <xsl:variable name="location">
                                                        <xsl:apply-templates select="@href" mode="value"/>
                                                    </xsl:variable>
                                                    <xsl:if test="not(starts-with($location, 'http://'))">
                                                        <xsl:value-of select="$root"/>
                                                    </xsl:if>
                                                    <xsl:value-of select="$location"/>
                                                </xsl:attribute>
                                                <xsl:apply-templates/>
                                            </xsl:element>
                                        </li>
                                    </xsl:for-each>
                                </ul>
                            </li>
                        </xsl:for-each>
                    </ul>
                </div>
            </div>
        </div>
    </xsl:template>

    <xsl:template name="css">
        <link href="{$root}styles/pivot.css" rel="stylesheet" type="text/css"/>
    </xsl:template>

    <xsl:template name="envelope">
        <xsl:apply-templates/>
    </xsl:template>
</xsl:stylesheet>
