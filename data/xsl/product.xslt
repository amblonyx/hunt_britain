<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" indent="yes"/>

<xsl:template match="/hunt">

	<div class="product-data">

	<h3>Outcome</h3>
    <xsl:for-each select="outcome">		
		<p><xsl:value-of select="intro"/></p>
		<xsl:if test="//hunt/style='elimination'">
			<h3>Options: <xsl:value-of select="count(selection/option)"/></h3>
			<ol>
			<xsl:apply-templates select="descendant::option" />
			</ol>
		</xsl:if>
	</xsl:for-each>
	
	<h3>Clues: <xsl:value-of select="count(clues/clue)"/></h3>
    <xsl:for-each select="clues/*">		
		<div class="clue well">
			<xsl:if test="name()='clue'">
				<h4>Clue <xsl:value-of select="@number"/></h4>
			</xsl:if>
			<xsl:apply-templates select="*" />
		</div>
	</xsl:for-each>
	</div>
</xsl:template>

<xsl:template match="option">
	<li>
		<span class="label"><xsl:value-of select="@id"/></span>
		<span>
			<xsl:attribute name="class"><xsl:value-of select="name()"/></xsl:attribute>
			<xsl:value-of select="content"/>
		</span><br/>
		<em><xsl:value-of select="comment"/></em>
	</li>
</xsl:template>

<xsl:template match="output">
	<div class="output">
		<xsl:apply-templates select="*" />
	</div>
</xsl:template>

<xsl:template match="*">
	<xsl:if test="name()!='output'">
		<div>
			<span class="label"><xsl:value-of select="name()"/></span>
			<span>
				<xsl:attribute name="class"><xsl:value-of select="name()"/></xsl:attribute>
				<xsl:if test="@id != ''">
					<b><xsl:value-of select="@id"/>=</b>
				</xsl:if>
				<xsl:value-of select="."/>
			</span><br/>
		</div>
	</xsl:if>
</xsl:template>

</xsl:stylesheet>