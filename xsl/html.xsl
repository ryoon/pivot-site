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
                var pageTracker = _gat._getTracker("UA-7977275-3");
                pageTracker._trackPageview();
                } catch(err) {
				}
				</script>
            </head>

            <body>
                <xsl:apply-templates select="body" mode="value"/>
            </body>
        </html>
    </xsl:template>

    <!-- <body> content gets wrapped within the site header, content envelope, and footer -->
    <xsl:template match="body" mode="value">
        <div id="wrapper">
            <div id="main">
                <div id="header">
                    <!-- Pivot Logo -->
                    <xsl:element name="div">
                        <xsl:attribute name="class">
                            <xsl:choose>
                                <xsl:when test="boolean(/document/properties/home)">logoHome</xsl:when>
                                <xsl:otherwise>logo</xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                        <a href="/index.html">
                            <img src="/images/logo.png" alt="{$project/title}"
                                title="{$project/title} Homepage"/>
                        </a>
                    </xsl:element>
                    <!-- ASF Logo -->
					<div xmlns="" class="logoASF">
						<a href="http://www.apache.org/">
							<img src="/images/asf_logo_wide_transp.png" alt="Apache" title="Apache Homepage"/>
						</a>
					</div>

                    <!-- Tagline -->
                    <div class="tagline">
                        <img src="/images/tagline.png" alt="{$project/tagline}" style="visibility:hidden"/>
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
                                            <xsl:value-of select="'/'"/>
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
                                                                <xsl:value-of select="concat('/demos/', @id, '.html')"/>
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
                                                        <xsl:value-of select="'/'"/>
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

                <!-- Trademark on name -->
                <div class="footerLinks">
                	Apache Pivot, Pivot, Apache, and the Apache Pivot project logo are trademarks of The Apache Software Foundation.
                </div>
            </div>
        </div>
    </xsl:template>

    <xsl:template name="css">
        <link href="/styles/pivot.css" rel="stylesheet" type="text/css"/>
        <link href="/styles/pivot_print.css" rel="stylesheet" type="text/css" media="print"/>
    </xsl:template>

    <xsl:template name="envelope">
        <xsl:apply-templates/>
    </xsl:template>

    <!-- <application> translates to Javascript that creates an applet -->
    <xsl:template match="application">
        <script type="text/javascript" src="https://java.com/js/deployJava.js"></script>

        <script type="text/javascript">
            <!-- Base attributes -->
            var attributes = {
                code:"org.apache.pivot.wtk.BrowserApplicationContext$HostApplet",
                width:"<xsl:value-of select="@width"/>",
                height:"<xsl:value-of select="@height"/>"
            };

            <!-- Additional attributes -->
            <xsl:for-each select="attributes/*">
                attributes.<xsl:value-of select="name(.)"/> = '<xsl:value-of select="."/>';
            </xsl:for-each>

            <!-- Archive attribute -->
            var libraries = [];
            <xsl:variable name="signed" select="libraries/@signed"/>
            <xsl:for-each select="libraries/library">
                <xsl:text><![CDATA[libraries.push("]]></xsl:text>
                <xsl:value-of select="'/lib/pivot-'"/>
                <xsl:value-of select="."/>
                <xsl:value-of select="'-'"/>
                <xsl:value-of select="$version"/>
                <xsl:if test="$signed">
                    <xsl:value-of select="'.signed'"/>
                </xsl:if>
                <xsl:value-of select="'.jar'"/>
                <xsl:text><![CDATA[");
                ]]></xsl:text>
            </xsl:for-each>

            <xsl:choose>
                <xsl:when test='$signed'>
                    libraries.push("/lib/svgSalamander-tiny.signed.jar");
                </xsl:when>
                <xsl:otherwise>
                    libraries.push("/lib/svgSalamander-tiny.jar");
                </xsl:otherwise>
            </xsl:choose>

            attributes.archive = libraries.join(",");

            <!-- Base parameters -->
            var parameters = {
                codebase_lookup:false,
                application_class_name:'<xsl:value-of select="@class"/>'
            };

            <!-- Java arguments -->
            var javaArguments = ["-Dsun.awt.noerasebackground=true",
                "-Dsun.awt.erasebackgroundonresize=true"];

            <xsl:if test="java-arguments">
                <xsl:for-each select="java-arguments/*">
                    javaArguments.push("-D<xsl:value-of select="name(.)"/>=<xsl:apply-templates/>");
                </xsl:for-each>
            </xsl:if>

            parameters.java_arguments = javaArguments.join(" ");

            <!-- Startup properties -->
            <xsl:if test="startup-properties">
                var startupProperties = [];
                <xsl:for-each select="startup-properties/*">
                    startupProperties.push("<xsl:value-of select="name(.)"/>=<xsl:apply-templates/>");
                </xsl:for-each>
                parameters.startup_properties = startupProperties.join("&amp;");
            </xsl:if>

            <!-- System properties -->
            <xsl:if test="system-properties">
                var systemProperties = [];
                <xsl:for-each select="system-properties/*">
                    systemProperties.push("<xsl:value-of select="name(.)"/>=<xsl:apply-templates/>");
                </xsl:for-each>
                parameters.system_properties = systemProperties.join("&amp;");
            </xsl:if>

            deployJava.runApplet(attributes, parameters, "1.6");
        </script>
    </xsl:template>
</xsl:stylesheet>
