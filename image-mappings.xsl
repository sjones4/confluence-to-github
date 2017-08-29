<?xml version="1.0" encoding="UTF-8"?>
<!--
Transform the image mapping xml to some bash commands
-->
<xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  >

  <xsl:output method="text"/>

  <xsl:template match="/"><xsl:for-each select="images/image">mkdir -p out/wiki/$(dirname '<xsl:value-of select="@path"/>')
cp '<xsl:value-of select="@attachment"/>' 'out/wiki/<xsl:value-of select="@path"/><xsl:text>'
</xsl:text>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>
