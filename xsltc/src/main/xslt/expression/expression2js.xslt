<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:exslt="http://exslt.org/common" exclude-result-prefixes="exslt">

    <xsl:import href="../util.xslt"/>
    <xsl:import href="expression-tokenize.xslt"/>

    <xsl:template match="@*" mode="expression2js">
        <xsl:param name="nodeVariableName">node</xsl:param>
        <xsl:param name="valuesVariableName">values</xsl:param>
        <xsl:message>
            EXPRESSION: <xsl:value-of select="."/>
        </xsl:message>
        <xsl:variable name="tokensFragment">
            <tokens>
                <xsl:apply-templates select="." mode="expression-tokenize"/>
            </tokens>
        </xsl:variable>
        <xsl:variable name="tokensNodeSet" select="exslt:node-set($tokensFragment)"/>
        <xsl:message>
            TOKENS: <xsl:copy-of select="$tokensNodeSet"/>
        </xsl:message>
        <xsl:variable name="treeFragment">
            <tree>
                <xsl:apply-templates select="$tokensNodeSet" mode="expression-tokens-to-tree"/>
            </tree>
        </xsl:variable>
        <xsl:message>
            TREE: <xsl:copy-of select="$treeFragment"/>
        </xsl:message>
        <xsl:variable name="treeNodeSet" select="exslt:node-set($treeFragment)"/>
        <xsl:variable name="result">
            <xsl:apply-templates select="$treeNodeSet" mode="expression-tree-to-javascript">
                <xsl:with-param name="nodeVariableName" select="$nodeVariableName"/>
                <xsl:with-param name="valuesVariableName" select="$valuesVariableName"/>
            </xsl:apply-templates>
        </xsl:variable>
        <xsl:message>
            RESULT: <xsl:value-of select="$result"/>
        </xsl:message>
        <xsl:value-of select="$result"/>
    </xsl:template>

</xsl:stylesheet>