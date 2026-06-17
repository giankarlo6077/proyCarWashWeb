Imports System.Data
Imports System.Web.UI
Imports System.Web.UI.WebControls

Partial Class capaPresentacion_MantenimientoProducto
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        CType(Master, Site_master).OpcionActiva = "mantenimiento"
        If Not IsPostBack Then
            listar("")
        End If
    End Sub

    Private Sub listar(ByVal dato As String)
        Try
            Dim obj As New capaNegocio.clsProducto()
            Dim dt As DataTable = obj.listarIdNombre(dato)
            Dim tabla As New DataTable()
            tabla.Columns.Add("Id")
            tabla.Columns.Add("Nombre")
            tabla.Columns.Add("stock")
            tabla.Columns.Add("vigencia")
            tabla.Columns.Add("Precio")
            tabla.Columns.Add("TipoProducto")
            tabla.Columns.Add("Marca")
            For Each fila As DataRow In dt.Rows
                tabla.Rows.Add(fila("idproducto"), fila("producto"), fila("stock"), fila("vigencia"),
                               fila("precioactual"), fila("tipoproducto"), fila("marcaproducto"))
            Next
            tblProducto.DataSource = tabla
            tblProducto.DataBind()
        Catch ex As Exception
            lblMsg.Text = "Error al listar productos: " & ex.Message
            lblMsg.CssClass = "msg show err"
        End Try
    End Sub

    Protected Sub btnBuscar_Click(sender As Object, e As EventArgs) Handles btnBuscar.Click
        listar(txtbuscador.Text)
    End Sub

End Class
