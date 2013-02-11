<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" indent="yes"/>

<xsl:template match="/hunt">
      <xsl:for-each select="clues/clue">		
          <h2><xsl:value-of select="number"/></h2>
          <xsl:value-of select="output/direction"/>
      </xsl:for-each>
</xsl:template>

</xsl:stylesheet>