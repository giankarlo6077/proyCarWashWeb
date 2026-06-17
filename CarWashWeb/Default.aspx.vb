Imports System.Data

Partial Class _Default
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        CType(Master, Site_master).OpcionActiva = "inicio"
        If Not IsPostBack Then
            cargarResumen()
        End If
    End Sub

    Private Sub cargarResumen()
        Try
            Dim objProd As New capaNegocio.clsProducto()
            litProductos.Text = objProd.listarIdNombre("").Rows.Count.ToString()
            litPapelera.Text = objProd.listarDadosDeBaja().Rows.Count.ToString()

            Dim objMarca As New capaNegocio.clsMarca()
            litMarcas.Text = objMarca.listarMarca().Rows.Count.ToString()

            Dim objTipo As New capaNegocio.clsTipoProducto()
            litTipos.Text = objTipo.listarTipoProducto().Rows.Count.ToString()
        Catch ex As Exception
            lblMsg.Text = "No se pudo cargar el resumen: " & ex.Message
            lblMsg.CssClass = "msg show err"
        End Try
    End Sub

End Class
