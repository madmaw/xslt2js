<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:b="urn:xmlns:25hoursaday-com:bookstore">

    <xsl:template match="b:bookstore">
        <book-titles>
            <xsl:apply-templates select="b:book/b:title"/>
        </book-titles>
    </xsl:template>

    <xsl:template match="b:title">
        <xsl:copy-of select="." />
    </xsl:template>
</xsl:stylesheet>