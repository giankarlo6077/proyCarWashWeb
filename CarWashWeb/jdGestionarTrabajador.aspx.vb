Imports System.Data
Imports capaNegocio

Partial Class jdGestionarTrabajador
    Inherits System.Web.UI.Page

    Dim objTrabajador As New clsTrabajador()
    Dim objTipoTrabajador As New clsTipoTrabajador()

    ' Propiedad para guardar el ID en el contexto de la solicitud Web (ViewState)
    Public Property idTrabajador As Integer
        Get
            If ViewState("idTrabajador") Is Nothing Then
                Return 0
            Else
                Return Convert.ToInt32(ViewState("idTrabajador"))
            End If
        End Get
        Set(ByVal value As Integer)
            ViewState("idTrabajador") = value
        End Set
    End Property

    '========================================
    ' PAGE LOAD
    '========================================
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        ' Protección de Sesión del Sistema
        If Session("Usuario") Is Nothing Then
            Response.Redirect("jdInicioSesion.aspx")
            Exit Sub
        End If

        If Not Page.IsPostBack Then
            lblMensaje.Text = ""
            cargarSexo()
            cargarTipoTrabajador()

            ' Evaluar si viene un ID por parámetro QueryString (Edición)
            If Not String.IsNullOrEmpty(Request.QueryString("id")) Then
                Dim idTemp As Integer = 0
                If Integer.TryParse(Request.QueryString("id"), idTemp) Then
                    Me.idTrabajador = idTemp
                    cargarTrabajador()
                    btnRegistrar.Text = "Modificar"
                    ' Deshabilitamos el botón limpiar en modo edición para cuidar la consistencia
                    btnLimpiar.Visible = False
                End If
            Else
                ' Configuración por defecto para registros nuevos
                Me.idTrabajador = 0
                btnRegistrar.Text = "Registrar"
                txtCodigo.Text = "AUTO"
                chkActivo.Checked = True
            End If
        End If
    End Sub

    '========================================
    ' CARGAR SEXO
    '========================================
    Sub cargarSexo()
        cboSexo.Items.Clear()
        cboSexo.Items.Add(New ListItem("-- Seleccione --", ""))
        cboSexo.Items.Add(New ListItem("M", "M"))
        cboSexo.Items.Add(New ListItem("F", "F"))
    End Sub

    '========================================
    ' CARGAR TIPOS DE TRABAJADOR
    '========================================
    Sub cargarTipoTrabajador()
        Try
            Dim dt As DataTable = objTipoTrabajador.listarTipoTrabajador()
            cboTipoTrabajador.DataSource = dt
            cboTipoTrabajador.DataTextField = "tipoTrabajador"
            cboTipoTrabajador.DataValueField = "idTipoTrabajador"
            cboTipoTrabajador.DataBind()

            ' Añadir elemento inicial neutro
            cboTipoTrabajador.Items.Insert(0, New ListItem("-- Seleccione --", ""))
        Catch ex As Exception
            MostrarError("Error al cargar los tipos de trabajador: " & ex.Message)
        End Try
    End Sub

    '========================================
    ' CARGAR DATOS
    '========================================
    Sub cargarTrabajador()
        Try
            Dim fila As DataRow = objTrabajador.obtenerTrabajadorXid(Me.idTrabajador)

            If fila IsNot Nothing Then
                txtCodigo.Text = fila("idTrabajador").ToString()
                txtNombre.Text = fila("trabajador").ToString()
                txtTelefono.Text = fila("telefono").ToString()
                txtDni.Text = fila("dni").ToString()
                txtCorreo.Text = fila("correo").ToString()

                If cboSexo.Items.FindByValue(fila("sexo").ToString()) IsNot Nothing Then
                    cboSexo.SelectedValue = fila("sexo").ToString()
                End If

                chkActivo.Checked = Convert.ToBoolean(fila("estado"))

                If cboTipoTrabajador.Items.FindByValue(fila("idTipoTrabajador").ToString()) IsNot Nothing Then
                    cboTipoTrabajador.SelectedValue = fila("idTipoTrabajador").ToString()
                End If
            Else
                MostrarError("No se pudieron recuperar los detalles del trabajador solicitado.")
            End If
        Catch ex As Exception
            MostrarError("Error al recuperar datos del registro: " & ex.Message)
        End Try
    End Sub

    '========================================
    ' VALIDAR CAMPOS
    '========================================
    Function validarCampos() As Boolean
        If txtCorreo.Text.Trim() <> "" Then
            If Not txtCorreo.Text.Contains("@") Then
                MostrarError("El formato del correo electrónico ingresado es inválido.")
                Return False
            End If
        End If

        If txtNombre.Text.Trim() = "" Then
            MostrarError("Por favor, ingrese el nombre completo del trabajador.")
            Return False
        End If

        If txtDni.Text.Trim() = "" Then
            MostrarError("Por favor, introduzca el número de DNI.")
            Return False
        End If

        If Not IsNumeric(txtDni.Text) Then
            MostrarError("El número de DNI debe contener únicamente dígitos numéricos.")
            Return False
        End If

        If txtDni.Text.Trim().Length <> 8 Then
            MostrarError("El DNI debe poseer exactamente 8 dígitos.")
            Return False
        End If

        If txtTelefono.Text.Trim() = "" Then
            MostrarError("Por favor, ingrese el número telefónico de contacto.")
            Return False
        End If

        If Not IsNumeric(txtTelefono.Text) Then
            MostrarError("El campo teléfono debe contener solo caracteres numéricos.")
            Return False
        End If

        If txtTelefono.Text.Trim().Length <> 9 Then
            MostrarError("El número telefónico debe constar de 9 dígitos.")
            Return False
        End If

        If cboSexo.SelectedIndex <= 0 Then
            MostrarError("Seleccione el género correspondiente del trabajador.")
            Return False
        End If

        If cboTipoTrabajador.SelectedIndex <= 0 Then
            MostrarError("Seleccione un rol o tipo de trabajador válido.")
            Return False
        End If

        Try
            If objTrabajador.existeDNI(txtDni.Text.Trim(), Me.idTrabajador) Then
                MostrarError("El número de DNI ingresado ya se encuentra registrado en el sistema.")
                Return False
            End If
        Catch ex As Exception
            MostrarError("Error al verificar duplicidad de documento: " & ex.Message)
            Return False
        End Try

        Return True
    End Function

    '========================================
    ' REGISTRAR / MODIFICAR
    '========================================
    Protected Sub btnRegistrar_Click(ByVal sender As Object, ByVal e As EventArgs)
        If Not validarCampos() Then Exit Sub

        Try
            If Me.idTrabajador = 0 Then
                '================================
                ' REGISTRAR NUEVO
                '================================
                objTrabajador.registrarTrabajador(
                    txtNombre.Text.Trim(),
                    txtTelefono.Text.Trim(),
                    txtDni.Text.Trim(),
                    cboSexo.SelectedValue,
                    txtCorreo.Text.Trim(),
                    chkActivo.Checked,
                    CInt(cboTipoTrabajador.SelectedValue),
                    1
                )

                ' Redirección directa al listado principal con confirmación implícita
                Response.Redirect("jdMantenimientoTrabajador.aspx")
            Else
                '================================
                ' MODIFICAR EXISTENTE
                '================================
                objTrabajador.modificarTrabajador(
                    Me.idTrabajador,
                    txtNombre.Text.Trim(),
                    txtTelefono.Text.Trim(),
                    txtDni.Text.Trim(),
                    cboSexo.SelectedValue,
                    txtCorreo.Text.Trim(),
                    chkActivo.Checked,
                    CInt(cboTipoTrabajador.SelectedValue),
                    1
                )

                Response.Redirect("jdMantenimientoTrabajador.aspx")
            End If
        Catch ex As Exception
            MostrarError("Ocurrió un inconveniente al procesar la solicitud: " & ex.Message)
        End Try
    End Sub

    '========================================
    ' ACCIONES DE BOTONERA ADICIONAL
    '========================================
    Protected Sub btnLimpiar_Click(ByVal sender As Object, ByVal e As EventArgs)
        limpiar()
    End Sub

    Protected Sub btnCancelar_Click(ByVal sender As Object, ByVal e As EventArgs)
        Response.Redirect("jdMantenimientoTrabajador.aspx")
    End Sub

    Protected Sub btnGestionar_Click(ByVal sender As Object, ByVal e As EventArgs)
        ' En entorno web, abrimos el formulario para gestionar roles/tipos
        Response.Redirect("jdGestionarTipoTrabajador.aspx")
    End Sub

    '========================================
    ' MÉTODOS AUXILIARES
    '========================================
    Sub limpiar()
        txtCodigo.Text = "AUTO"
        txtNombre.Text = ""
        txtTelefono.Text = ""
        txtDni.Text = ""
        txtCorreo.Text = ""
        cboSexo.SelectedIndex = 0
        cboTipoTrabajador.SelectedIndex = 0
        chkActivo.Checked = True
        lblMensaje.Text = ""
    End Sub

    Private Sub MostrarError(ByVal mensaje As String)
        lblMensaje.CssClass = "mensaje-error"
        lblMensaje.Text = mensaje
    End Sub

    Private Sub MostrarExito(ByVal mensaje As String)
        lblMensaje.CssClass = "mensaje-exito"
        lblMensaje.Text = mensaje
    End Sub
End Class