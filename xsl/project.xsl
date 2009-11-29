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
    <!-- Output method -->
    <xsl:output method="html" encoding="UTF-8" indent="no"
        doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
        doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/>

    <!-- Parameters (overrideable) -->
    <xsl:param name="release"/>
    <xsl:param name="base"/>
    <xsl:param name="demos"/>

    <!-- Variables (not overrideable) -->
    <xsl:variable name="wiki">http://cwiki.apache.org/PIVOT</xsl:variable>
    <xsl:variable name="asf">http://www.apache.org</xsl:variable>
    <xsl:variable name="jira">http://issues.apache.org/jira/browse/PIVOT</xsl:variable>
    <xsl:variable name="project" select="document('project.xml')/project"/>
    <xsl:variable name="demos-index" select="document(concat($demos, '/index.xml'))/document"/>
    <xsl:variable name="item-group" select="//document/@item-group"/>

    <!-- <document> translates to an HTML page -->
    <xsl:template match="document">
        <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
                <title>
                    <xsl:choose>
                        <xsl:when test="properties/title">
                            <xsl:value-of select="properties/title"/>
                            <xsl:value-of select="' | '"/>
                        </xsl:when>
                    </xsl:choose>
                    <xsl:value-of select="$project/title"/>
                </title>
                <link href="{$base}styles/pivot.css" rel="stylesheet" type="text/css"/>

                <xsl:apply-templates select="head"/>

                <!-- Google Analytics Code -->
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
                <div id="wrapper">
                    <div id="main">
                        <div id="header">
                            <xsl:variable name="logoClass">
                                <xsl:choose>
                                    <xsl:when test="boolean(properties/home)">logoHome</xsl:when>
                                    <xsl:otherwise>logo</xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            <div class="{$logoClass}">
                                <a href="{$base}index.html">
                                    <xsl:variable name="title" select="$project/title"/>
                                    <img src="{$base}images/logo.png" alt="{$title}" title="{$title} Homepage"/>
                                </a>
                            </div>
                            <div class="tagline">
                                <xsl:variable name="tagline" select="$project/tagline"/>
                                <img src="{$base}images/tagline.png" alt="{$tagline}"/>
                            </div>
                            <ul class="navi">
                                <xsl:call-template name="global-navigation"/>
                            </ul>
                        </div>

                        <xsl:apply-templates select="body"/>
                    </div>

                    <div id="footer" class="group">
                        <div class="footerLogo">
                            <xsl:for-each select="$project/copyright/message">
                                <xsl:if test="position()&gt;1"><br/></xsl:if>
                                <xsl:value-of select="."/>
                            </xsl:for-each>
                        </div>

                        <div class="footerLinks">
                            <ul class="footerMenuGr">
                                <xsl:call-template name="footer-navigation"/>
                            </ul>
                        </div>
                    </div>
                </div>
            </body>
        </html>
    </xsl:template>

    <!-- The main site navigation -->
    <xsl:template name="global-navigation">
        <xsl:apply-templates select="$project/global-items/item"/>
    </xsl:template>

    <!-- The footer site navigation -->
    <xsl:template name="footer-navigation">
        <xsl:for-each select="$project/item-groups/item-group">
            <li>
                <strong><xsl:value-of select="@name"/></strong>
                <ul>
                    <xsl:choose>
                        <xsl:when test="@id='demos'">
                            <xsl:apply-templates select="$demos-index/body//application-item[boolean(@footer)]"/>
                        </xsl:when>
                    </xsl:choose>
                    <xsl:apply-templates select="item[not(@footer='false')]"/>
                </ul>
            </li>
        </xsl:for-each>
    </xsl:template>

    <!-- <head> content gets passed through -->
    <xsl:template match="head">
        <xsl:apply-templates/>
    </xsl:template>

    <!-- <body> content gets passed through -->
    <xsl:template match="body">
        <xsl:apply-templates/>
    </xsl:template>

    <!-- <item> gets translated to a decorated hyperlink -->
    <xsl:template match="item">
        <xsl:variable name="href">
            <xsl:choose>
                <xsl:when test="starts-with(@href, '~wiki')">
                    <xsl:value-of select="$wiki"/><xsl:value-of select="substring(@href,6)"/>
                </xsl:when>
                <xsl:when test="starts-with(@href, '~asf')">
                    <xsl:value-of select="$asf"/><xsl:value-of select="substring(@href,5)"/>
                </xsl:when>
                <xsl:when test="starts-with(@href, '~jira')">
                    <xsl:value-of select="$jira"/><xsl:value-of select="substring(@href,6)"/>
                </xsl:when>
                <xsl:when test="starts-with(@href, '~release')">
                    <xsl:value-of select="$base"/>
                    <xsl:value-of select="$release"/>
                    <xsl:value-of select="substring(@href,9)"/>
                </xsl:when>
                <xsl:when test="@href='~download'">
                    <xsl:value-of select="$base"/>
                    <xsl:value-of select="'download.cgi#'"/>
                    <xsl:value-of select="$release"/>
                </xsl:when>
                <xsl:when test="starts-with(@href, 'http://')">
                    <xsl:value-of select="@href"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$base"/>
                    <xsl:value-of select="@href"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="@caption">
                <xsl:variable name="class" select="@class"/>
                <li class="{$class}">
                    <a href="{$href}">
                        <strong><xsl:value-of select="@name"/></strong>
                        <em><xsl:value-of select="@caption"/></em>
                        <xsl:choose>
                            <xsl:when test=".">
                                <p><xsl:apply-templates/></p>
                            </xsl:when>
                        </xsl:choose>
                    </a>
                </li>
            </xsl:when>
            <xsl:otherwise>
                <li><a href="{$href}"><xsl:value-of select="@name"/></a></li>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--
    <application-item> is similar to an <item>, but its metadata comes from the application
    document's properties rather than from the element itself
    -->
    <xsl:template match="application-item">
        <xsl:variable name="demo" select="document(concat($demos, '/', @id, '.xml'))/document"/>
        <xsl:variable name="href">
            <xsl:value-of select="concat($base, 'demos/', @id, '.html')"/>
        </xsl:variable>
        <xsl:variable name="target">
            <xsl:choose>
                <xsl:when test="boolean(@new-window)">_new</xsl:when>
                <xsl:otherwise>_self</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <li><a href="{$href}" target="{$target}"><xsl:value-of select="$demo/properties/title"/></a></li>
    </xsl:template>

    <!--
    <application-item>[<remote/>] gets special handling to look for the application properties as
    a nested element rather than in a separate document (remote applications don't have an XML
    descriptor)
    -->
    <xsl:template match="application-item[remote]">
        <xsl:variable name="target">
            <xsl:choose>
                <xsl:when test="boolean(@new-window)">_new</xsl:when>
                <xsl:otherwise>_self</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="href" select="remote/@href"/>
        <li><a href="{$href}" target="{$target}"><xsl:value-of select="properties/title"/></a></li>
    </xsl:template>

    <!-- Process everything else by just passing it through -->
    <xsl:template match="*|@*">
        <xsl:copy>
            <xsl:apply-templates select="@*|*|text()"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
