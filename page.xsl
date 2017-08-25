<?xml version="1.0" encoding="UTF-8"?>
<!--
Transform an xml page to github markdown
-->
<xsl:stylesheet version="1.0" 
  xmlns:ac="http://www.atlassian.com/schema/confluence/4/ac/" 
  xmlns:ri="http://www.atlassian.com/schema/confluence/4/ri/"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  >

<!-- Markdown output
# header1
## header 2
### header 3

[text here](http://url.goes/here)

![alt text here](http://image.url/here)

**bold**
_italic_

`code`

* dot
* item
* * list

1. number
1. item
1. 1. list

> block quoted
-->

  <xsl:output method="text"/>

  <xsl:variable name="lower" select="'abcdefghijklmnopqrstuvwxyz'" />
  <xsl:variable name="upper" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />

  <xsl:variable name="title-was" select="' \/:*?\|&quot;&lt;&gt;'"/>
  <xsl:variable name="title-now" select="'-----------'"/>


  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template name="string-replace-all">
    <xsl:param name="text" />
    <xsl:param name="replace" />
    <xsl:param name="by" />
    <xsl:choose>
      <xsl:when test="$text = '' or $replace = ''or not($replace)" >
        <xsl:value-of select="$text" />
      </xsl:when>
      <xsl:when test="contains($text, $replace)">
        <xsl:value-of select="substring-before($text,$replace)" disable-output-escaping="yes"/>
        <xsl:value-of select="$by" disable-output-escaping="yes"/>
        <xsl:call-template name="string-replace-all">
          <xsl:with-param name="text" select="substring-after($text,$replace)" />
          <xsl:with-param name="replace" select="$replace" />
          <xsl:with-param name="by" select="$by" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text" disable-output-escaping="yes" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!-- 
  We should escape all markdown special characters with backslash

    \  backslash
    `  backtick
    *  asterisk
    _  underscore
    {} curly braces
    [] square brackets
    () parentheses
    #  hash mark
    +  plus sign
    -  minus sign (hyphen)
    .  dot
    !  exclamation mark
  -->
  <xsl:template match="text()">
    <xsl:choose>
      <xsl:when test="contains(.,'*')">
        <xsl:call-template name="string-replace-all">
          <xsl:with-param name="text" select="." />
          <xsl:with-param name="replace" select="'*'" />
          <xsl:with-param name="by" select="'\*'" />
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="contains(.,'[')">
        <xsl:call-template name="string-replace-all">
          <xsl:with-param name="text" select="." />
          <xsl:with-param name="replace" select="'['" />
          <xsl:with-param name="by" select="'\['" />
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="normalize-space(.) != ''">
        <xsl:value-of select="."/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="h1[text()]">
# <xsl:copy>
      <xsl:apply-templates select="node()"/>
    </xsl:copy><xsl:text>
</xsl:text>    
  </xsl:template>

  <xsl:template match="h2[text()]">
## <xsl:copy>
      <xsl:apply-templates select="node()"/>
    </xsl:copy><xsl:text>
</xsl:text>
  </xsl:template>

  <xsl:template match="h3[text()]">
### <xsl:copy>
      <xsl:apply-templates select="node()"/>
    </xsl:copy><xsl:text>
</xsl:text>
  </xsl:template>

  <xsl:template match="p[boolean(../../th) or boolean(../../td)]"><xsl:copy>
      <xsl:apply-templates select="node()"/>
    </xsl:copy></xsl:template>

  <xsl:template match="p">
<xsl:copy>
      <xsl:apply-templates select="node()"/>
    </xsl:copy><xsl:text>

</xsl:text>
  </xsl:template>

  <!-- not supported? -->
  <xsl:template match="br[(count(../text()) &gt; 0) and (count(ancestor::table) &gt; 0)]">
    <xsl:text> </xsl:text>
  </xsl:template>

  <xsl:template match="br[(count(../text()) &gt; 0) and (count(ancestor::table) = 0)]">
<xsl:text>

</xsl:text><xsl:if test="count(ancestor::*[local-name() = 'ol' or local-name() = 'ul']) &gt; 0"><xsl:text>    </xsl:text></xsl:if>
  </xsl:template>

  <xsl:template match="em[boolean(strong)]|strong[boolean(em)]">
    <xsl:if test="normalize-space(.) != ''"> **_<xsl:value-of select="normalize-space(.)"/>_** </xsl:if> 
  </xsl:template>

  <xsl:template match="em">
    <xsl:if test="normalize-space(.) != ''"> _<xsl:value-of select="normalize-space(.)"/>_ </xsl:if> 
  </xsl:template>

  <xsl:template match="strong">
    <xsl:if test="normalize-space(.) != ''"> **<xsl:value-of select="normalize-space(.)"/>** </xsl:if> 
  </xsl:template>

  <xsl:template match="table">
      <xsl:text>
</xsl:text>
      <xsl:apply-templates select="tbody/tr[boolean(th)]" mode="content"/>
      <xsl:apply-templates select="tbody/tr[boolean(th)]" mode="dash"/>
      <xsl:apply-templates select="tbody/tr[boolean(td)]" mode="content"/>
      <xsl:text>

</xsl:text>
  </xsl:template>

  <xsl:template match="tr[boolean(th)]" mode="content">
| <xsl:apply-templates select="th" mode="content" />
  </xsl:template>

  <xsl:template match="tr[boolean(th)]" mode="dash">
| <xsl:apply-templates select="th" mode="dash" />
  </xsl:template>

  <!-- <xsl:template match="th|td" mode="content">
    <xsl:value-of select="normalize-space(.)"/> | </xsl:template> -->

  <xsl:template match="th|td" mode="content"><xsl:apply-templates select="."/> | </xsl:template>

  <xsl:template match="th" mode="dash"> --- | </xsl:template>

  <xsl:template match="tr[boolean(td)]" mode="content">
| <xsl:apply-templates select="td" mode="content" />
  </xsl:template>

  <xsl:template match="ul[boolean(ancestor::table)]">
    <xsl:text disable-output-escaping="yes">&lt;ul></xsl:text>
      <xsl:apply-templates select="li" mode="html" />
    <xsl:text disable-output-escaping="yes">&lt;/ul></xsl:text>   
  </xsl:template>

  <xsl:template match="li" mode="html">
    <xsl:text disable-output-escaping="yes">&lt;li></xsl:text>
      <xsl:copy>
        <xsl:apply-templates select="node()"/>
      </xsl:copy>   
    <xsl:text disable-output-escaping="yes">&lt;/li></xsl:text>
  </xsl:template>

  <xsl:template match="ul">
    <xsl:copy>
      <xsl:apply-templates select="li" mode="unordered-list" />
    </xsl:copy><xsl:text>

</xsl:text><xsl:if test="count(ancestor::*[local-name() = 'ol' or local-name() = 'ul']) &gt; 0"><xsl:text>    </xsl:text></xsl:if>
  </xsl:template>

  <xsl:template match="ol">
    <xsl:copy>
      <xsl:apply-templates select="li" mode="ordered-list" />
    </xsl:copy><xsl:text>

</xsl:text><xsl:if test="count(ancestor::*[local-name() = 'ol' or local-name() = 'ul']) &gt; 0"><xsl:text>    </xsl:text></xsl:if>
  </xsl:template>

  <xsl:template match="li" mode="unordered-list">
    <xsl:text>
</xsl:text>
    <xsl:if test="count(ancestor::*[local-name() = 'ol' or local-name() = 'ul']) &gt; 1"><xsl:text>    </xsl:text></xsl:if>* <xsl:copy>
      <xsl:apply-templates select="node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="li" mode="ordered-list">
    <xsl:text>
</xsl:text>
    <xsl:if test="count(ancestor::*[local-name() = 'ol' or local-name() = 'ul']) &gt; 1"><xsl:text>    </xsl:text></xsl:if>1. <xsl:copy>
      <xsl:apply-templates select="node()"/>
    </xsl:copy>
  </xsl:template>

  <!--
    // [text here](http://url.goes/here)  : for external content
    <ac:link>
      <ri:url ri:value="http:///"/>
    </ac:link>

    // [[Link Text|WikiLink]]             : for pages
    <ac:link>
      <ri:page ri:space-key="QA" ri:content-title="Public IP Address Reservation" ri:version-at-save="51"/>
    </ac:link>
    <ac:link>
      <ri:page ri:space-key="QA" ri:content-title="Public IP Address Reservation" ri:version-at-save="51"/>
      <ac:plain-text-link-body><![CDATA[public IP address reservation]]></ac:plain-text-link-body>
    </ac:link>
  -->
  <xsl:template match="ac:link[boolean(ri:url)]">[<xsl:copy>
      <xsl:apply-templates select="ac:link-body|ac:plain-text-link-body"/>
    </xsl:copy>](<xsl:value-of select="ri:url/@ri:value"/>)</xsl:template>
  <xsl:template match="ac:link[boolean(ri:page) and (boolean(ac:link-body) or boolean(ac:plain-text-link-body))]">[[<xsl:copy>
      <xsl:apply-templates select="ac:link-body|ac:plain-text-link-body"/>
    </xsl:copy>|<xsl:value-of select="translate(ri:page/@ri:content-title,$title-was,$title-now)"/>]]</xsl:template>
  <xsl:template match="ac:link[boolean(ri:page) and not (boolean(ac:link-body) or boolean(ac:plain-text-link-body))]">[[<xsl:value-of select="ri:page/@ri:content-title"/>|<xsl:value-of select="translate(ri:page/@ri:content-title,$title-was,$title-now)"/>]]</xsl:template>

  <xsl:template match="a[boolean(@href)]">[<xsl:copy>
      <xsl:apply-templates select="node()"/>
    </xsl:copy>](<xsl:value-of select="@href"/>)</xsl:template>


  <xsl:template match="ac:structured-macro[@ac:name = 'anchor']">
  </xsl:template>

  <!-- 
      <ac:image ac:width="800"> // ac:height="266" ac:width="634"
        <ri:attachment ri:filename="cluster_modules.png" ri:version-at-save="1"/>
      </ac:image>
      TODO: support width/height? {:height="36px" width="36px"}
  -->
  <xsl:template match="ac:image">![<xsl:value-of select="@ac:alt"/>](images/<xsl:value-of select="/page/space"/>/<xsl:value-of select="ri:attachment/@ri:filename"/>)</xsl:template>

  <!--
    <ac:structured-macro ac:name="code" ac:schema-version="1" ac:macro-id="d4ad3989-bce6-4b8c-b174-fcc0e9bf9a42">
      <ac:parameter ac:name="language">bash</ac:parameter>
      <ac:parameter ac:name="theme">Confluence</ac:parameter>
      <ac:parameter ac:name="linenumbers">true</ac:parameter>
      <ac:plain-text-body><![CDATA[com.eucalyptus.empyrean.registration.map.cluster=clusterservice]]></ac:plain-text-body>
    </ac:structured-macro>
  -->
  <xsl:template match="ac:structured-macro[@ac:name = 'code']">
```<xsl:value-of select="ac:parameter[@ac:name = 'language']"/><xsl:text>
</xsl:text><xsl:value-of select="ac:plain-text-body"/>
```
</xsl:template>

  <xsl:template match="pre">
```
<xsl:copy>
      <xsl:apply-templates select="node()"/>
</xsl:copy>
```
</xsl:template>

  <!--
    <ac:structured-macro ac:name="jira" ac:schema-version="1" ac:macro-id="eb159d99-7736-4a43-829e-3fe7580a453f">
      <ac:parameter ac:name="server">JIRA (eucalyptus.atlassian.net)</ac:parameter>
      <ac:parameter ac:name="serverId">40f6fb44-bbe5-3de3-b0a9-368eb548a761</ac:parameter>
      <ac:parameter ac:name="key">EUCA-13384</ac:parameter>
    </ac:structured-macro>
    https://eucalyptus.atlassian.net/browse/EUCA-13384
  -->
  <xsl:template match="ac:structured-macro[@ac:name = 'jira']">[<xsl:value-of select="ac:parameter[@ac:name = 'key']"/><xsl:text> </xsl:text><xsl:value-of select="ac:parameter[@ac:name = 'server']"/>](https://<xsl:value-of select="substring-after(substring-before(ac:parameter[@ac:name = 'server'],')'),'(')"/>/browse/<xsl:value-of select="ac:parameter[@ac:name = 'key']"/>)</xsl:template>

  <!--
      <ac:structured-macro ac:name="toc" ac:schema-version="1" ac:macro-id="6010db53-d32b-4ea9-b8b1-abca61d9a75c">
        <ac:parameter ac:name="minLevel">2</ac:parameter>
        <ac:parameter ac:name="indent">10px</ac:parameter>
        <ac:parameter ac:name="printable">false</ac:parameter>
      </ac:structured-macro>

    * [Scope](#scope)
      * [API](#api)
      * [Long Identifiers](#long-identifiers)
    * [API Details](#api-details)
  -->
  <xsl:template match="ac:structured-macro[@ac:name = 'toc']">
    <!-- TODO flat toc support? -->
    <xsl:variable name="min-level">
      <xsl:choose>
        <xsl:when test="ac:parameter[@ac:name = 'minLevel']">
          <xsl:value-of select="ac:parameter[@ac:name = 'minLevel']"/>   
        </xsl:when> 
        <xsl:otherwise>1</xsl:otherwise> 
      </xsl:choose>
    </xsl:variable>
    <xsl:for-each select="/page/body/*[(local-name() = 'h1' or local-name() = 'h2' or local-name() = 'h3') and text()]">
      <xsl:choose>
        <xsl:when test="number(substring-after(local-name(),'h')) - $min-level = 2">
          <xsl:text>    * [</xsl:text>
          <xsl:value-of select="node()"/>
          <xsl:text>](#</xsl:text>
          <xsl:value-of select="translate(translate(node(),$upper,$lower),' ','-')"/>
          <xsl:text>)
</xsl:text>
        </xsl:when> 
        <xsl:when test="number(substring-after(local-name(),'h')) - $min-level = 1">
          <xsl:text>  * [</xsl:text>
          <xsl:value-of select="node()"/>
          <xsl:text>](#</xsl:text>
          <xsl:value-of select="translate(translate(node(),$upper,$lower),' ','-')"/>
          <xsl:text>)
</xsl:text>
        </xsl:when> 
        <xsl:when test="number(substring-after(local-name(),'h')) - $min-level = 0">
          <xsl:text>* [</xsl:text>
          <xsl:value-of select="node()"/>
          <xsl:text>](#</xsl:text>
          <xsl:value-of select="translate(translate(node(),$upper,$lower),' ','-')"/>
          <xsl:text>)
</xsl:text>
        </xsl:when>             
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="category">[[category.<xsl:value-of select="."/>]] 
</xsl:template>

  <xsl:template match="page">
    <xsl:copy>
      <xsl:apply-templates select="body"/>
    </xsl:copy>

*****

<xsl:copy>
      <xsl:apply-templates select="category"/>
    </xsl:copy>
  </xsl:template>


</xsl:stylesheet>
