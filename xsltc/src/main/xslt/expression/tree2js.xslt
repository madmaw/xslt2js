<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:exslt="http://exslt.org/common" exclude-result-prefixes="exslt">

    <xsl:import href="../util.xslt"/>

    <xsl:template match="add" mode="expression-tree-to-javascript">
        <xsl:text>(</xsl:text>
        <xsl:for-each select="*">
            <xsl:if test="position() > 1">
                <xsl:text> + </xsl:text>
            </xsl:if>
            <xsl:apply-templates select="." mode="expression-tree-to-javascript">

            </xsl:apply-templates>
        </xsl:for-each>
        <xsl:text>)</xsl:text>
    </xsl:template>

    <xsl:template match="number-literal" mode="expression-tree-to-javascript">
        <xsl:value-of select="."/>
    </xsl:template>

</xsl:stylesheet>