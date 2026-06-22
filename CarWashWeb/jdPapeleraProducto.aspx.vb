Imports System.Data
Imports capaNegocio

Partial Class jdPapeleraProducto
    Inherits System.Web.UI.Page

    Dim objProducto As New clsProducto()

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Session("Usuario") Is Nothing Then
            Response.Redirect("jdInicioSesion.aspx")
            Exit Sub
        End If

        If Not Page.IsPostBack Then
            listar()
        End If
    End Sub

    Private Sub listar()
        Try
            dgvPapelera.DataSource = objProducto.listarDadosDeBaja()
            dgvPapelera.DataBind()
        Catch ex As Exception
            MostrarError("Error al listar productos dados de baja: " & ex.Message)
        End Try
    End Sub

    '====================== SELECCIONAR FILA ======================
    Protected Sub dgvPapelera_RowCommand(ByVal sender As Object, ByVal e As GridViewCommandEventArgs)
        If e.CommandName = "Seleccionar" Then
            txtId.Text = Convert.ToString(e.CommandArgument)
            lblMensaje.Text = ""
        End If
    End Sub

    '====================== BOTONERA ======================
    Protected Sub btnRecuperar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnRecuperar.Click
        If txtId.Text.Trim() = "" Then
            MostrarError("Seleccione un producto para recuperar")
            Exit Sub
        End If
        Try
            objProducto.recuperarProducto(Convert.ToInt32(txtId.Text))
            MostrarExito("PRODUCTO RECUPERADO")
            txtId.Text = ""
            listar()
        Catch ex As Exception
            MostrarError("Error al recuperar: " & ex.Message)
        End Try
    End Sub

    Protected Sub btnEliminar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnEliminar.Click
        If txtId.Text.Trim() = "" Then
            MostrarError("Escoja un producto para eliminar")
            Exit Sub
        End If
        Try
            objProducto.eliminarProducto(Convert.ToInt32(txtId.Text))
            MostrarExito("PRODUCTO ELIMINADO")
            txtId.Text = ""
            listar()
        Catch ex As Exception
            MostrarError("Error al eliminar: " & ex.Message)
        End Try
    End Sub

    Protected Sub btnActualizar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnActualizar.Click
        txtId.Text = ""
        lblMensaje.Text = ""
        listar()
    End Sub

    '====================== MENSAJES ======================
    Private Sub MostrarError(ByVal mensaje As String)
        lblMensaje.CssClass = "mensaje-error"
        lblMensaje.Text = mensaje
    End Sub

    Private Sub MostrarExito(ByVal mensaje As String)
        lblMensaje.CssClass = "mensaje-exito"
        lblMensaje.Text = mensaje
    End Sub

End Class
