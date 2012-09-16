<xsl:stylesheet
        version="1.1"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:exslt="http://exslt.org/common"
        exclude-result-prefixes="exslt">

    <xsl:import href="../util.xslt"/>

    <xsl:template match="list" mode="expression-lists-to-tree">
        <xsl:param name="from-index" select="1"/>
        <xsl:param name="to-index" select="count(*) - 1"/>

        <xsl:choose>
            <xsl:when test="$to-index > $from-index">
                <xsl:variable name="highest-precedence-index">
                    <xsl:apply-templates select="." mode="expression-lists-to-tree-get-highest-precedence-operation-index">
                        <xsl:with-param name="index" select="$from-index"/>
                        <xsl:with-param name="to-index" select="$to-index"/>
                    </xsl:apply-templates>
                </xsl:variable>
                <xsl:variable name="highest-precedence-element" select="*[position() = $highest-precedence-index]"/>
                <xsl:element name="{name($highest-precedence-element)}">
                    <xsl:attribute name="index">
                        <xsl:value-of select="$highest-precedence-element/@index"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="." mode="expression-lists-to-tree">
                        <xsl:with-param name="from-index" select="$from-index"/>
                        <xsl:with-param name="to-index" select="$highest-precedence-index - 1"/>
                    </xsl:apply-templates>
                    <xsl:apply-templates select="." mode="expression-lists-to-tree">
                        <xsl:with-param name="from-index" select="$highest-precedence-index + 1"/>
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
    </xsl:template>

    <xsl:template match="list" mode="expression-lists-to-tree-get-highest-precedence-operation-index">
        <xsl:param name="index"/>
        <xsl:param name="to-index"/>
        <xsl:param name="max-precedence-so-far" select="-1"/>
        <xsl:param name="max-index-so-far"/>
        <xsl:choose>
            <xsl:when test="$to-index >= $index">
                <xsl:variable name="precedence">
                    <xsl:apply-templates select="*[$index]" mode="expression-lists-to-tree-get-precedence"/>
                </xsl:variable>
                <xsl:variable name="max-precedence">
                    <xsl:choose>
                        <xsl:when test="$max-precedence-so-far > $precedence">
                            <xsl:value-of select="$max-precedence-so-far"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$precedence"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="max-index">
                    <xsl:choose>
                        <xsl:when test="$max-precedence-so-far > $precedence">
                            <xsl:value-of select="$max-index-so-far"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$index"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:apply-templates select="." mode="expression-lists-to-tree-get-highest-precedence-operation-index">
                    <xsl:with-param name="index" select="$index + 1"/>
                    <xsl:with-param name="to-index" select="$to-index"/>
                    <xsl:with-param name="max-index-so-far" select="$max-index"/>
                    <xsl:with-param name="max-precedence-so-far" select="$max-precedence"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$max-index-so-far"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*" mode="expression-lists-to-tree-get-precedence" priority="1">
        <xsl:text>0</xsl:text>
    </xsl:template>

    <xsl:template match="add|subtract" mode="expression-lists-to-tree-get-precedence" priority="2">
        <xsl:text>1</xsl:text>
    </xsl:template>

    <xsl:template match="multiply" mode="expression-lists-to-tree-get-precedence" priority="2">
        <xsl:text>2</xsl:text>
    </xsl:template>

    <xsl:template match="divide" mode="expression-lists-to-tree-get-precedence" priority="2">
        <xsl:text>3</xsl:text>
    </xsl:template>

    <xsl:template match="word|variable|string-literal|number-literal" mode="expression-lists-to-tree-value">
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

    <xsl:template match="open-bracket"  mode="expression-lists-to-tree-value">

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