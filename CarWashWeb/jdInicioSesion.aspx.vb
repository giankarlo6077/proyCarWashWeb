Imports capaNegocio

Partial Class jdInicioSesion
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            lblError.Text = ""
        End If
    End Sub

    Protected Sub btnIngresar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnIngresar.Click

        lblError.Text = ""

        Dim usuario As String = txtUsuario.Text.Trim()
        Dim contrasena As String = txtPassword.Text.Trim()

        ' Validación básica de campos vacíos
        If usuario = "" Or contrasena = "" Then
            lblError.Text = "Por favor, ingrese usuario y contraseña."
            Exit Sub
        End If

        Try
            Dim objTrabajador As New clsTrabajador()

            ' 1. Verificamos si el usuario está activo/vigente
            Dim estaVigente As Boolean = objTrabajador.ValidarVigencia(usuario)

            If Not estaVigente Then
                lblError.Text = "El usuario no existe o se encuentra inactivo."
                Exit Sub
            End If

            ' 2. Validamos usuario y contraseña
            Dim nombreTrabajador As String = objTrabajador.Login(usuario, contrasena)

            If nombreTrabajador <> "" Then
                ' Login correcto -> Guardamos datos en sesión
                Session("Usuario") = usuario
                Session("NombreTrabajador") = nombreTrabajador

                ' Redirigimos al menú principal
                Response.Redirect("FrmMenuPrincipal.aspx")
            Else
                lblError.Text = "Usuario o contraseña incorrectos."
            End If

        Catch ex As Exception
            lblError.Text = "Error al iniciar sesión: " & ex.Message
        End Try

    End Sub
End Class