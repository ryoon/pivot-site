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
  <xsl:output method="xml"
              encoding="UTF-8"
              doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
              doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
              indent="yes"/>

  <!-- Defined parameters (overrideable) -->
  <xsl:param name="relative-path" select="'.'"/>

  <!-- Process an entire document into an HTML page -->
  <xsl:template match="document">
    <xsl:variable name="project" select="document('project.xml')/project"/>
    <xsl:variable name="group">
      <xsl:value-of select="@group"/>
    </xsl:variable>

    <html xmlns="http://www.w3.org/1999/xhtml">
      <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <title><xsl:value-of select="properties/title"/> | <xsl:value-of select="$project/title"/></title>
        <link href="styles/pivot.css" rel="stylesheet" type="text/css"/>

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
              <div class="logo">
                <a href="index.html">
                  <img src="images/logo.png" alt="Apache Pivot" title="Apache Pivot Homepage"/>
                </a>
              </div>
              <div class="tagline">
                <img src="images/tagline.png" alt="Rich Internet Applications (RIA) in Java (tm)"/>
              </div>

              <xsl:comment>MAIN NAVIGATION</xsl:comment>
              <ul class="navi">
                <xsl:apply-templates select="$project/global/item"/>
              </ul>
            </div>

            <div id="contentBase" class="group">
              <h1><xsl:value-of select="properties/title"/></h1>

              <xsl:comment>GROUP NAVIGATION</xsl:comment>
              <ul class="naviLeft">
                <xsl:apply-templates select="$project/groups/group[@id=$group]/item"/>
              </ul>

              <xsl:comment>CONTENT</xsl:comment>
              <div class="content">
                <xsl:apply-templates select="body/section"/>
              </div>
            </div>
          </div>

          <div id="footer" class="group">
            <div class="footerLogo">Copyright (c) 1999-2010, The Apache Software Foundation.</div>

            <div class="footerLinks">
              <ul class="footerMenuGr">
                <xsl:apply-templates select="$project/groups/group"/>
              </ul>
            </div>
          </div>
        </div>
      </body>
    </html>
  </xsl:template>

  <!-- Process a group -->
  <xsl:template match="group">
    <li>
      <strong><xsl:value-of select="@name"/></strong>
      <ul>
        <xsl:apply-templates select="item"/>
      </ul>
    </li>
  </xsl:template>

  <!-- Process a navigation item -->
  <xsl:template match="item">
    <xsl:variable name="href">
      <xsl:choose>
        <xsl:when test="starts-with(@href, 'http://')">
          <xsl:value-of select="@href"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$relative-path"/><xsl:value-of select="@href"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <li><a href="{$href}"><xsl:value-of select="@name"/></a></li>
  </xsl:template>

  <!-- Process a section -->
  <xsl:template match="section">
    <xsl:variable name="name">
      <xsl:value-of select="@name"/>
    </xsl:variable>
    <a name="{$name}"><h2><xsl:value-of select="@name"/></h2></a>
    <xsl:apply-templates/>
  </xsl:template>

  <!-- Process everything else by just passing it through -->
  <xsl:template match="*|@*">
    <xsl:copy>
      <xsl:apply-templates select="@*|*|text()"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
