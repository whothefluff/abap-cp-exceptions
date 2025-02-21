"! <p class="shorttext synchronized" lang="EN">Excs. with No Check of RAISING Clause with t100 message</p>
class zcx_cp_no_check definition
                      public
                      inheriting from cx_no_check
                      create public.

  public section.

    interfaces: zif_cp_exception.

    aliases: text for zif_cp_exception~text,
             stack_trace for zif_cp_exception~stack_trace.

    class-methods class_constructor.

    "! <p class="shorttext synchronized" lang="EN">Creates an exception. Can use a t100 msg</p>
    "!
    "! @parameter i_t100_message | <p class="shorttext synchronized" lang="EN">t100 message</p>
    "! @parameter i_previous | <p class="shorttext synchronized" lang="EN"></p>
    methods constructor
              importing
                i_t100_message type ref to if_t100_message optional
                i_previous like previous optional
                preferred parameter i_t100_message.

  protected section.

    types: begin of _t_error,
             old type sy-msgty,
             rap type if_abap_behv_message=>t_severity,
           end of _t_error,
           _t_errors type hashed table of zcx_cp_no_check=>_t_error with unique key old.

    methods _t100_vars
              importing
                i_t100_message type ref to if_t100_message
              returning
                value(r_val) type symsg.

    methods _msg_vars
              importing
                i_t100_message type ref to if_t100_message
              returning
                value(r_val) type symsg.

    methods _set_and_use_xco
              importing
                i_vars type symsg
              returning
                value(r_self) type ref to zcx_cp_no_check.

    class-data _errors type zcx_cp_no_check=>_t_errors.

    data _stack_trace type ref to if_xco_cp_call_stack.

    data _xco_message type ref to if_xco_message.

endclass.
class zcx_cp_no_check implementation.

  method class_constructor.

    _errors = value #( ( old = 'E'
                         rap = if_abap_behv_message=>severity-error )
                       ( old = 'I'
                         rap = if_abap_behv_message=>severity-information )
                       ( old = 'W'
                         rap = if_abap_behv_message=>severity-warning )
                       ( old = 'S'
                         rap = if_abap_behv_message=>severity-success ) ).

  endmethod.
  method constructor ##ADT_SUPPRESS_GENERATION.

    constants calling_procedure type i value 2.

    super->constructor( previous = i_previous ).

    me->textid = value #( ).

    final(msg_vars) = _msg_vars( i_t100_message ).

    _set_and_use_xco( msg_vars ).

    _stack_trace = xco_cp=>current->call_stack->full( )->from->position( calling_procedure ).

    me->if_abap_behv_message~m_severity = value #( _errors[ old = msg_vars-msgty ]-rap default if_abap_behv_message=>severity-success ).

  endmethod.
  method _msg_vars.

    r_val = value symsg( let aux = cond symsg( when i_t100_message is bound
                                               then value #( base _t100_vars( i_t100_message )
                                                             msgid = i_t100_message->t100key-msgid
                                                             msgno = i_t100_message->t100key-msgno )
                                               else corresponding #( if_t100_message=>default_textid ) ) in
                         base aux
                         msgty = cond #( when aux-msgty is not initial
                                         then aux-msgty
                                         else 'E' ) ).

  endmethod.
  method _t100_vars.

    case type of i_t100_message.

      when type if_t100_dyn_msg into final(dyn).

        r_val = value symsg( msgty = dyn->msgty
                             msgv1 = dyn->msgv1
                             msgv2 = dyn->msgv2
                             msgv3 = dyn->msgv3
                             msgv4 = dyn->msgv4 ).

      when others.

        cl_message_helper=>set_msg_vars_for_if_t100_msg( i_t100_message ).

        r_val = value symsg( msgv1 = sy-msgv1
                             msgv2 = sy-msgv2
                             msgv3 = sy-msgv3
                             msgv4 = sy-msgv4 ).

    endcase.

  endmethod.
  method _set_and_use_xco.

    _xco_message = xco_cp=>message( i_vars ).

    _xco_message->write_to_t100_dyn_msg( me ).

    r_self = me.

  endmethod.
  method if_xco_news~get_messages.

    rt_messages = cast if_xco_news( _xco_message )->get_messages( ).

  endmethod.
  method if_xco_message~get_short_text.

    ro_short_text = _xco_message->get_short_text( ).

  endmethod.
  method if_xco_message~get_text.

    rv_text = _xco_message->get_text( ).

  endmethod.
  method if_xco_message~get_type.

    ro_type = _xco_message->get_type( ).

  endmethod.
  method if_xco_message~overwrite.

    ro_message = _xco_message->overwrite( iv_msgty = iv_msgty
                                          iv_msgid = iv_msgid
                                          iv_msgno = iv_msgno
                                          iv_msgv1 = iv_msgv1
                                          iv_msgv2 = iv_msgv2
                                          iv_msgv3 = iv_msgv3
                                          iv_msgv4 = iv_msgv4 ).

  endmethod.
  method if_xco_message~place_string.

    ro_message = _xco_message->place_string( iv_string = iv_string
                                             iv_msgv1 = abap_false
                                             iv_msgv2 = abap_false
                                             iv_msgv3 = abap_false
                                             iv_msgv4 = abap_false ).

  endmethod.
  method if_xco_message~write_to_t100_dyn_msg.

    _xco_message->write_to_t100_dyn_msg( io_t100_dyn_msg ).

  endmethod.
  method zif_cp_exception~stack_trace.

    r_val = _stack_trace.

  endmethod.
  method zif_cp_exception~text.

    r_val = cl_message_helper=>get_text_for_message( me ).

  endmethod.

endclass.
