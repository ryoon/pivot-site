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

  <!-- Defined parameters (overrideable) -->
  <xsl:param name="release"/>
  <xsl:param name="base"/>
  <xsl:param name="wiki" select="'http://cwiki.apache.org/PIVOT'"/>
  <xsl:param name="asf" select="'http://www.apache.org'"/>
  <xsl:param name="jira" select="'http://issues.apache.org/jira/browse/PIVOT'"/>

  <!-- Defined variables (not overrideable) -->
  <xsl:variable name="project" select="document('project.xml')/project"/>
  <xsl:variable name="item-group">
    <xsl:value-of select="//document/@item-group"/>
  </xsl:variable>

  <!-- Process an entire document into an HTML page -->
  <xsl:template match="document">
    <xsl:variable name="logoClass">
      <xsl:choose>
        <xsl:when test="@main='true'">
          <xsl:value-of select="'logoHome'"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="'logo'"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

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
              <div class="{$logoClass}">
                <a href="{$base}index.html">
                  <img src="{$base}images/logo.png" alt="Apache Pivot" title="Apache Pivot Homepage"/>
                </a>
              </div>
              <div class="tagline">
                <img src="{$base}images/tagline.png" alt="Rich Internet Applications (RIA) in Java (tm)"/>
              </div>

              <xsl:comment>MAIN NAVIGATION</xsl:comment>
              <ul class="navi">
                <xsl:apply-templates select="$project/global-items/item"/>
              </ul>
            </div>

            <xsl:apply-templates select="body"/>
          </div>

          <div id="footer" class="group">
            <div class="footerLogo">
              Copyright (c) 1999-2010,<br/>The Apache Software Foundation.
            </div>

            <div class="footerLinks">
              <ul class="footerMenuGr">
                <xsl:apply-templates select="$project/item-groups/item-group"/>
              </ul>
            </div>
          </div>
        </div>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="head">
      <xsl:apply-templates/>
  </xsl:template>

  <!-- Process an item group -->
  <xsl:template match="item-group">
    <li>
      <strong><xsl:value-of select="@name"/></strong>
      <ul>
        <xsl:apply-templates select="item[not(@footer='false')]"/>
      </ul>
    </li>
  </xsl:template>

  <!-- Process a navigation item -->
  <xsl:template match="item">
    <xsl:variable name="class">
      <xsl:value-of select="@class"/>
    </xsl:variable>

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
        <xsl:otherwise>
          <xsl:value-of select="$base"/>
          <xsl:value-of select="@href"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:choose>
        <xsl:when test="@caption">
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

  <!-- Process everything else by just passing it through -->
  <xsl:template match="*|@*">
    <xsl:copy>
      <xsl:apply-templates select="@*|*|text()"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
