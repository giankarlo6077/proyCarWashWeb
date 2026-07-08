Imports System.Data
Imports com.somee.wspruebacarwash2

Partial Class jdMantenimientoProducto
    Inherits System.Web.UI.Page

    Dim objProducto As New WSv1

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Session("Usuario") Is Nothing Then
            Response.Redirect("jdInicioSesion.aspx")
            Exit Sub
        End If
        Seguridad.ExigirAdministrador(Me)

        If Not Page.IsPostBack Then
            listar("")
        End If
    End Sub

    Private Sub listar(ByVal dato As String)
        Try
            dgvProductos.DataSource = objProducto.listarIdNombre(dato)
            dgvProductos.DataBind()
        Catch ex As Exception
            lblMensaje.CssClass = "mensaje-error"
            lblMensaje.Text = "Error al listar productos: " & ex.Message
        End Try
    End Sub

    Protected Sub btnBuscar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnBuscar.Click
        listar(txtbuscador.Text.Trim())
    End Sub

    Protected Sub btnGestionar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnGestionar.Click
        Response.Redirect("jdGestionarProducto.aspx")
    End Sub

End Class
