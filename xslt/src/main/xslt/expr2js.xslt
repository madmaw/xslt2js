<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:exslt="http://exslt.org/common" exclude-result-prefixes="exslt">

    <xsl:import href="util.xslt"/>

    <xsl:template match="@*" mode="expression-compile">
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

    <xsl:template match="@*" mode="expression-tokenize">
        <token index="{position()}"><xsl:value-of select="."/></token>
    </xsl:template>

    <xsl:template match="tokens" mode="expression-tokens-to-tree">
        <xsl:copy-of select="."/>
    </xsl:template>

    <xsl:template match="tree" mode="expression-tree-to-javascript">
        <xsl:param name="nodeVariableName">node</xsl:param>
        <xsl:param name="valuesVariableName">values</xsl:param>
        <xsl:value-of select="$nodeVariableName"/>
    </xsl:template>

</xsl:stylesheet>