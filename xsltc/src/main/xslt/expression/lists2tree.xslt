<xsl:stylesheet
        version="1.1"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:exslt="http://exslt.org/common"
        exclude-result-prefixes="exslt">

    <xsl:import href="../util.xslt"/>

    <xsl:template match="list" mode="expression-lists-to-tree">
        <xsl:param name="from-index" select="1"/>
        <xsl:param name="to-index" select="count(*) - 1"/>
        <xsl:if test="$to-index >= $from-index">
            <xsl:choose>
                <xsl:when test="$to-index > $from-index">
                    <xsl:variable name="lowest-precedence-index">
                        <xsl:apply-templates select="." mode="expression-lists-to-tree-get-lowest-precedence-operation-index">
                            <xsl:with-param name="index" select="$from-index"/>
                            <xsl:with-param name="to-index" select="$to-index"/>
                        </xsl:apply-templates>
                    </xsl:variable>
                    <xsl:variable name="lowest-precedence-element" select="*[position() = $lowest-precedence-index]"/>

                    <xsl:element name="{name($lowest-precedence-element)}">
                        <xsl:attribute name="index">
                            <xsl:value-of select="$lowest-precedence-element/@index"/>
                        </xsl:attribute>
                        <xsl:value-of select="$lowest-precedence-element/text()"/>
                        <xsl:apply-templates select="." mode="expression-lists-to-tree">
                            <xsl:with-param name="from-index" select="$from-index"/>
                            <xsl:with-param name="to-index" select="$lowest-precedence-index - 1"/>
                        </xsl:apply-templates>
                        <xsl:apply-templates select="." mode="expression-lists-to-tree">
                            <xsl:with-param name="from-index" select="$lowest-precedence-index + 1"/>
                            <xsl:with-param name="to-index" select="$to-index"/>
                        </xsl:apply-templates>
                    </xsl:element>
                </xsl:when>
                <xsl:when test="name(*[$from-index]) = 'list'">
                    <xsl:apply-templates select="*[$from-index]" mode="expression-lists-to-tree"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:copy-of select="*[$from-index]"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

    <xsl:template match="list" mode="expression-lists-to-tree-get-lowest-precedence-operation-index">
        <xsl:param name="index"/>
        <xsl:param name="to-index"/>
        <xsl:param name="min-precedence-so-far" select="10001"/>
        <xsl:param name="min-index-so-far"/>
        <xsl:choose>
            <xsl:when test="$to-index >= $index">
                <xsl:variable name="precedence">
                    <xsl:apply-templates select="*[$index]" mode="expression-lists-to-tree-get-precedence"/>
                </xsl:variable>
                <xsl:variable name="min-precedence">
                    <xsl:choose>
                        <xsl:when test="$precedence >= $min-precedence-so-far">
                            <xsl:value-of select="$min-precedence-so-far"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$precedence"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="min-index">
                    <xsl:choose>
                        <xsl:when test="$precedence >= $min-precedence-so-far">
                            <xsl:value-of select="$min-index-so-far"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$index"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:apply-templates select="." mode="expression-lists-to-tree-get-lowest-precedence-operation-index">
                    <xsl:with-param name="index" select="$index + 1"/>
                    <xsl:with-param name="to-index" select="$to-index"/>
                    <xsl:with-param name="min-index-so-far" select="$min-index"/>
                    <xsl:with-param name="min-precedence-so-far" select="$min-precedence"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$min-index-so-far"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*" mode="expression-lists-to-tree-get-precedence" priority="1">
        <xsl:text>10000</xsl:text>
    </xsl:template>

    <xsl:template match="or" mode="expression-lists-to-tree-get-precedence" priority="2">
        <xsl:text>1</xsl:text>
    </xsl:template>

    <xsl:template match="and" mode="expression-lists-to-tree-get-precedence" priority="2">
        <xsl:text>2</xsl:text>
    </xsl:template>

    <xsl:template match="add|subtract" mode="expression-lists-to-tree-get-precedence" priority="2">
        <xsl:text>5</xsl:text>
    </xsl:template>

    <xsl:template match="multiply|divide|child" mode="expression-lists-to-tree-get-precedence" priority="2">
        <xsl:text>6</xsl:text>
    </xsl:template>

    <xsl:template match="equals" mode="expression-lists-to-tree-get-precedence" priority="2">
        <xsl:text>7</xsl:text>
    </xsl:template>

    <xsl:template match="word|variable|string-literal|number-literal|boolean-literal" mode="expression-lists-to-tree-value">
        <!-- current value should always be a word, constant, or variable -->
        <!-- look ahead -->
        <xsl:variable name="index" select="@index"/>

        <xsl:variable name="previousTree">
            <xsl:copy-of select="."/>
        </xsl:variable>
        <xsl:apply-templates select="../*[@index=$index+1]" mode="expression-lists-to-tree-operation">
            <xsl:with-param name="previous-tree" select="exslt:node-set($previousTree)"/>
        </xsl:apply-templates>

    </xsl:template>

    <xsl:template match="child" mode="expression-lists-to-tree-operation">
        <xsl:param name="previous-tree"/>
        <!-- work out the next tree -->
        <xsl:variable name="index" select="@index"/>
        <xsl:variable name="next-tree">
            <xsl:apply-templates select="../*[@index=$index+1]" mode="expression-lists-to-tree-value"/>
        </xsl:variable>

    </xsl:template>

</xsl:stylesheet>