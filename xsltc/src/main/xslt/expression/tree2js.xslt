<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:exslt="http://exslt.org/common" exclude-result-prefixes="exslt">

    <xsl:import href="../util.xslt"/>

    <xsl:template match="tree" mode="expression-tree-to-javascript">
        <xsl:param name="nodeVariableName">node</xsl:param>
        <xsl:param name="valuesVariableName">values</xsl:param>
        <xsl:value-of select="$nodeVariableName"/>
    </xsl:template>

</xsl:stylesheet>