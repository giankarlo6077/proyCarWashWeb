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

    '====================== ACCIONES POR FILA (Recuperar / Eliminar) ======================
    Protected Sub dgvPapelera_RowCommand(ByVal sender As Object, ByVal e As GridViewCommandEventArgs)
        Dim id As Integer
        If Not Integer.TryParse(Convert.ToString(e.CommandArgument), id) Then Exit Sub

        Select Case e.CommandName
            Case "Recuperar"
                Try
                    objProducto.recuperarProducto(id)
                    MostrarExito("PRODUCTO RECUPERADO")
                    listar()
                Catch ex As Exception
                    MostrarError("Error al recuperar: " & ex.Message)
                End Try

            Case "Quitar"
                Try
                    objProducto.eliminarProducto(id)
                    MostrarExito("PRODUCTO ELIMINADO")
                    listar()
                Catch ex As Exception
                    MostrarError("Error al eliminar: " & ex.Message)
                End Try
        End Select
    End Sub

    Protected Sub btnActualizar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnActualizar.Click
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
