Imports System.Data
Imports capaNegocio

Partial Public Class jdModificarPersona
        Inherits System.Web.UI.Page

        ' ══════════════════════════════════════════════
        '  CONSTANTES DE ESTILO PARA MENSAJES
        ' ══════════════════════════════════════════════
        Private Const CSS_ERROR As String = "gp-alert error"
        Private Const CSS_SUCCESS As String = "gp-alert success"
        Private Const CSS_WARNING As String = "gp-alert warning"

        ' ══════════════════════════════════════════════
        '  PAGE LOAD
        ' ══════════════════════════════════════════════
        Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
            If Not IsPostBack Then
                CargarDepartamentos()
                CargarGridView()
                txtIdCliente.Enabled = False
                btnModificar.Enabled = False
                btnEliminar.Enabled = False
                OcultarMensaje()
            End If
        End Sub

        ' ══════════════════════════════════════════════
        '  MENSAJES AL USUARIO
        ' ══════════════════════════════════════════════
        Private Sub MostrarMensaje(texto As String, css As String)
            lblMensaje.Text = texto
            lblMensaje.CssClass = css
            lblMensaje.Visible = True
        End Sub

        Private Sub OcultarMensaje()
            lblMensaje.Text = ""
            lblMensaje.Visible = False
        End Sub

        ' ══════════════════════════════════════════════
        '  CARGA DE UBIGEO EN CASCADA
        ' ══════════════════════════════════════════════
        Private Sub CargarDepartamentos()
            Dim objCliente As New clsCliente()
            Try
                Dim dt As DataTable = objCliente.listarDepartamentos()
                cboDepartamento.DataSource = dt
                cboDepartamento.DataTextField = "departamento"
                cboDepartamento.DataValueField = "iddepartamento"
                cboDepartamento.DataBind()
                cboDepartamento.Items.Insert(0, New System.Web.UI.WebControls.ListItem("-- Seleccione --", "0"))
                cboDepartamento.SelectedIndex = 0

                cboProvincia.Items.Clear()
                cboProvincia.Items.Add(New System.Web.UI.WebControls.ListItem("-- Seleccione --", "0"))
                cboProvincia.Enabled = False

                cboDistrito.Items.Clear()
                cboDistrito.Items.Add(New System.Web.UI.WebControls.ListItem("-- Seleccione --", "0"))
                cboDistrito.Enabled = False
            Catch ex As Exception
                MostrarMensaje("Error al cargar departamentos: " & ex.Message, CSS_ERROR)
            End Try
        End Sub

        Protected Sub cboDepartamento_SelectedIndexChanged(sender As Object, e As EventArgs)
            OcultarMensaje()
            cboDistrito.Items.Clear()
            cboDistrito.Items.Add(New System.Web.UI.WebControls.ListItem("-- Seleccione --", "0"))
            cboDistrito.Enabled = False

            If cboDepartamento.SelectedValue = "0" Then
                cboProvincia.Items.Clear()
                cboProvincia.Items.Add(New System.Web.UI.WebControls.ListItem("-- Seleccione --", "0"))
                cboProvincia.Enabled = False
                Return
            End If

            Dim objCliente As New clsCliente()
            Try
                Dim idDepto As Integer = Convert.ToInt32(cboDepartamento.SelectedValue)
                Dim dt As DataTable = objCliente.listarProvincias(idDepto)
                cboProvincia.DataSource = dt
                cboProvincia.DataTextField = "provincia"
                cboProvincia.DataValueField = "idprovincia"
                cboProvincia.DataBind()
                cboProvincia.Items.Insert(0, New System.Web.UI.WebControls.ListItem("-- Seleccione --", "0"))
                cboProvincia.SelectedIndex = 0
                cboProvincia.Enabled = True
            Catch ex As Exception
                MostrarMensaje("Error al cargar provincias: " & ex.Message, CSS_ERROR)
            End Try
        End Sub

        Protected Sub cboProvincia_SelectedIndexChanged(sender As Object, e As EventArgs)
            OcultarMensaje()
            cboDistrito.Items.Clear()
            cboDistrito.Items.Add(New System.Web.UI.WebControls.ListItem("-- Seleccione --", "0"))
            cboDistrito.Enabled = False

            If cboProvincia.SelectedValue = "0" Then Return

            Dim objCliente As New clsCliente()
            Try
                Dim idProv As Integer = Convert.ToInt32(cboProvincia.SelectedValue)
                Dim dt As DataTable = objCliente.listarDistritos(idProv)
                cboDistrito.DataSource = dt
                cboDistrito.DataTextField = "distrito"
                cboDistrito.DataValueField = "iddistrito"
                cboDistrito.DataBind()
                cboDistrito.Items.Insert(0, New System.Web.UI.WebControls.ListItem("-- Seleccione --", "0"))
                cboDistrito.SelectedIndex = 0
                cboDistrito.Enabled = True
            Catch ex As Exception
                MostrarMensaje("Error al cargar distritos: " & ex.Message, CSS_ERROR)
            End Try
        End Sub

        ' ══════════════════════════════════════════════
        '  SEXO — checkboxes mutuamente excluyentes
        ' ══════════════════════════════════════════════
        Protected Sub chkMasculino_CheckedChanged(sender As Object, e As EventArgs)
            If chkMasculino.Checked Then chkFemenino.Checked = False
        End Sub

        Protected Sub chkFemenino_CheckedChanged(sender As Object, e As EventArgs)
            If chkFemenino.Checked Then chkMasculino.Checked = False
        End Sub

        ' ══════════════════════════════════════════════
        '  CARGAR GRIDVIEW
        ' ══════════════════════════════════════════════
        Private Sub CargarGridView()
            Dim objPersona As New clsPersona()
            Try
                Dim dt As DataTable = objPersona.listarPersonaMo()
                gvPersonas.DataSource = dt
                gvPersonas.DataBind()
            Catch ex As Exception
                MostrarMensaje("Error al cargar el listado de personas: " & ex.Message, CSS_ERROR)
            End Try
        End Sub

        ' ── Paginación ──
        Protected Sub gvPersonas_PageIndexChanging(sender As Object, e As System.Web.UI.WebControls.GridViewPageEventArgs)
            gvPersonas.PageIndex = e.NewPageIndex
            CargarGridView()
        End Sub

        ' ── Seleccionar fila → poblar formulario ──
        Protected Sub gvPersonas_SelectedIndexChanged(sender As Object, e As EventArgs)
            OcultarMensaje()
            Dim row As System.Web.UI.WebControls.GridViewRow = gvPersonas.SelectedRow

            txtIdCliente.Text = row.Cells(0).Text.Trim()
            txtNombreAp.Text = row.Cells(1).Text.Trim()

            ' Sexo
            Dim sexo As String = row.Cells(2).Text.Trim()
            chkMasculino.Checked = (sexo = "M")
            chkFemenino.Checked = (sexo = "F")

            txtDNI.Text = row.Cells(3).Text.Trim()
            txtDireccion.Text = row.Cells(4).Text.Trim()
            txtCorreo.Text = row.Cells(5).Text.Trim()
            txtTelefono.Text = row.Cells(6).Text.Trim()

            ' Fecha de nacimiento → formato yyyy-MM-dd para input[type=date]
            Dim rawFecha As String = row.Cells(7).Text.Trim()
            If rawFecha <> "" AndAlso rawFecha <> "&nbsp;" Then
                Try
                    Dim fechaNac As Date = Convert.ToDateTime(rawFecha)
                    txtFechaNac.Text = fechaNac.ToString("yyyy-MM-dd")
                Catch
                    txtFechaNac.Text = ""
                End Try
            End If

            btnModificar.Enabled = True
            btnEliminar.Enabled = True

            ' Nota: el ubigeo en cascada no se reconstruye automáticamente al seleccionar
            ' (requeriría consulta extra para encontrar depto/prov a partir del distrito).
            ' Se deja el ubigeo en blanco para que el usuario lo reseleccione si desea cambiarlo.
            CargarDepartamentos()
        End Sub

        ' ── RowDataBound: quitar &nbsp; de celdas vacías ──
        Protected Sub gvPersonas_RowDataBound(sender As Object, e As System.Web.UI.WebControls.GridViewRowEventArgs)
            ' Nada especial necesario; el formato de fecha se aplica via DataFormatString en el .aspx
        End Sub

        ' ══════════════════════════════════════════════
        '  BOTÓN MODIFICAR
        ' ══════════════════════════════════════════════
        Protected Sub btnModificar_Click(sender As Object, e As EventArgs)
            OcultarMensaje()

            ' — Validaciones —
            If txtIdCliente.Text.Trim() = "" Then
                MostrarMensaje("Seleccione una persona del listado.", CSS_WARNING)
                Return
            End If
            If txtNombreAp.Text.Trim() = "" Then
                MostrarMensaje("Ingrese los nombres y apellidos.", CSS_WARNING)
                Return
            End If
            If txtDNI.Text.Trim() = "" Then
                MostrarMensaje("Ingrese el N° DNI.", CSS_WARNING)
                Return
            End If
            If txtDNI.Text.Trim().Length <> 8 Then
                MostrarMensaje("El DNI debe tener exactamente 8 dígitos.", CSS_WARNING)
                Return
            End If
            If cboDistrito.SelectedValue = "0" OrElse cboDistrito.SelectedValue = "" Then
                MostrarMensaje("Seleccione el departamento, provincia y distrito.", CSS_WARNING)
                Return
            End If
            If Not chkMasculino.Checked AndAlso Not chkFemenino.Checked Then
                MostrarMensaje("Seleccione el sexo.", CSS_WARNING)
                Return
            End If
            If txtFechaNac.Text.Trim() = "" Then
                MostrarMensaje("Ingrese la fecha de nacimiento.", CSS_WARNING)
                Return
            End If

            ' — Validar fecha nacimiento —
            Dim fechaNac As Date
            If Not Date.TryParse(txtFechaNac.Text.Trim(), fechaNac) Then
                MostrarMensaje("La fecha de nacimiento no es válida.", CSS_WARNING)
                Return
            End If
            If fechaNac > Date.Today Then
                MostrarMensaje("La fecha de nacimiento no puede ser una fecha futura.", CSS_WARNING)
                Return
            End If
            Dim edad As Integer = Date.Today.Year - fechaNac.Year
            If fechaNac > Date.Today.AddYears(-edad) Then edad -= 1
            If edad < 18 Then
                MostrarMensaje("La persona debe ser mayor de 18 años.", CSS_WARNING)
                Return
            End If

            ' — Guardar —
            Dim sexo As String = If(chkMasculino.Checked, "M", "F")
            Dim objPersona As New clsPersona()
            Try
                objPersona.modificarPersona(
                    Convert.ToInt32(txtIdCliente.Text),
                    txtNombreAp.Text.Trim(),
                    txtDireccion.Text.Trim(),
                    txtDNI.Text.Trim(),
                    txtCorreo.Text.Trim(),
                    txtTelefono.Text.Trim(),
                    sexo,
                    Convert.ToInt32(cboDistrito.SelectedValue),
                    fechaNac
                )
                MostrarMensaje("✔ Persona modificada correctamente.", CSS_SUCCESS)
                LimpiarCampos()
                CargarGridView()
            Catch ex As Exception
                MostrarMensaje("Error al modificar la persona: " & ex.Message, CSS_ERROR)
            End Try
        End Sub

        ' ══════════════════════════════════════════════
        '  BOTÓN ELIMINAR
        ' ══════════════════════════════════════════════
        Protected Sub btnEliminar_Click(sender As Object, e As EventArgs)
            OcultarMensaje()

            If txtIdCliente.Text.Trim() = "" Then
                MostrarMensaje("No hay ninguna persona seleccionada.", CSS_WARNING)
                Return
            End If

            Dim objPersona As New clsPersona()
            Try
                objPersona.eliminarPersona(Convert.ToInt32(txtIdCliente.Text))
                MostrarMensaje("✔ Persona eliminada correctamente.", CSS_SUCCESS)
                LimpiarCampos()
                CargarGridView()
            Catch ex As Exception
                MostrarMensaje("Error al eliminar la persona: " & ex.Message, CSS_ERROR)
            End Try
        End Sub

        ' ══════════════════════════════════════════════
        '  BOTÓN LIMPIAR
        ' ══════════════════════════════════════════════
        Protected Sub btnLimpiar_Click(sender As Object, e As EventArgs)
            LimpiarCampos()
            OcultarMensaje()
        End Sub

        ' ══════════════════════════════════════════════
        '  BOTÓN CANCELAR
        ' ══════════════════════════════════════════════
        Protected Sub btnCancelar_Click(sender As Object, e As EventArgs)
            LimpiarCampos()
            OcultarMensaje()
            Response.Redirect("~/Default.aspx")   ' Redirige al inicio / menú principal
        End Sub

        ' ══════════════════════════════════════════════
        '  LIMPIAR CAMPOS
        ' ══════════════════════════════════════════════
        Private Sub LimpiarCampos()
            txtIdCliente.Text = ""
            txtNombreAp.Text = ""
            txtDNI.Text = ""
            txtDireccion.Text = ""
            txtCorreo.Text = ""
            txtTelefono.Text = ""
            txtFechaNac.Text = ""
            chkMasculino.Checked = False
            chkFemenino.Checked = False
            CargarDepartamentos()
            gvPersonas.SelectedIndex = -1
            btnModificar.Enabled = False
            btnEliminar.Enabled = False
        End Sub

End Class