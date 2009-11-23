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
  <xsl:include href="project.xsl"/>

  <xsl:variable name="jar-core">
    <xsl:value-of select="'../lib/pivot-core-'"/>
    <xsl:value-of select="$release"/>
    <xsl:value-of select="'.jar'"/>
  </xsl:variable>

  <xsl:variable name="jar-wtk">
    <xsl:value-of select="'../lib/pivot-wtk-'"/>
    <xsl:value-of select="$release"/>
    <xsl:value-of select="'.jar'"/>
  </xsl:variable>

  <xsl:variable name="jar-wtk-terra">
    <xsl:value-of select="'../lib/pivot-wtk-'"/>
    <xsl:value-of select="$release"/>
    <xsl:value-of select="'.terra.jar'"/>
  </xsl:variable>

  <xsl:variable name="jar-web">
    <xsl:value-of select="'../lib/pivot-web-'"/>
    <xsl:value-of select="$release"/>
    <xsl:value-of select="'.jar'"/>
  </xsl:variable>

  <xsl:variable name="jar-demos">
    <xsl:value-of select="'../lib/pivot-demos-'"/>
    <xsl:value-of select="$release"/>
    <xsl:value-of select="'.jar'"/>
  </xsl:variable>

  <xsl:variable name="jar-tutorials">
    <xsl:value-of select="'../lib/pivot-tutorials-'"/>
    <xsl:value-of select="$release"/>
    <xsl:value-of select="'.jar'"/>
  </xsl:variable>

  <xsl:variable name="jar-tools">
    <xsl:value-of select="'../lib/pivot-tools-'"/>
    <xsl:value-of select="$release"/>
    <xsl:value-of select="'.jar'"/>
  </xsl:variable>

  <xsl:template match="body">
    <div id="contentBase" class="group">
      <h1><xsl:value-of select="//document/properties/title"/></h1>

      <xsl:comment>GROUP NAVIGATION</xsl:comment>
      <ul class="naviLeft">
        <li><a href="getting-started.html">Getting Started</a></li>
      </ul>

      <xsl:comment>CONTENT</xsl:comment>
      <div class="content">
        <xsl:apply-templates/>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="demo">
    <script type="text/javascript" src="http://java.com/js/deployJava.js"></script>
    <script type="text/javascript">
      var attributes = {
          code:"org.apache.pivot.wtk.BrowserApplicationContext$HostApplet",
          style:"border:solid 1px #999999"
      };

      <xsl:for-each select="attributes/*">
        attributes.<xsl:value-of select="name(.)"/> = '<xsl:value-of select="."/>';
      </xsl:for-each>

      var libraries = [];
      <xsl:for-each select="libraries/library">
        <xsl:choose>
          <xsl:when test=".='core'">
            libraries.push('<xsl:value-of select="$jar-core"/>');
          </xsl:when>
          <xsl:when test=".='wtk'">
            libraries.push('<xsl:value-of select="$jar-wtk"/>');
            libraries.push('<xsl:value-of select="$jar-wtk-terra"/>');
          </xsl:when>
          <xsl:when test=".='web'">
            libraries.push('<xsl:value-of select="$jar-web"/>');
          </xsl:when>
          <xsl:when test=".='demos'">
            libraries.push('<xsl:value-of select="$jar-demos"/>');
          </xsl:when>
          <xsl:when test=".='tutorials'">
            libraries.push('<xsl:value-of select="$jar-tutorials"/>');
          </xsl:when>
          <xsl:when test=".='tools'">
            libraries.push('<xsl:value-of select="$jar-tools"/>');
          </xsl:when>
        </xsl:choose>
      </xsl:for-each>
      attributes.archive = libraries.join(",");

      var parameters = {
        codebase_lookup:false,
        java_arguments:"-Dsun.awt.noerasebackground=true -Dsun.awt.erasebackgroundonresize=true"
      };

      <xsl:for-each select="parameters/*">
        <xsl:variable name="parameter">
          <xsl:choose>
            <xsl:when test="name(.)='class-name'">
              <xsl:value-of select="'application_class_name'"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="name(.)"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        parameters.<xsl:value-of select="$parameter"/> = '<xsl:value-of select="."/>';
      </xsl:for-each>

      deployJava.runApplet(attributes, parameters, "1.6");
    </script>
  </xsl:template>
</xsl:stylesheet>
