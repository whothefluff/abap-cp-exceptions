interface zif_cp_exception public.

  interfaces: if_abap_behv_message,
              if_xco_message.

  "! <p class="shorttext synchronized" lang="EN">Returns this exception's text</p>
  "!
  "! @parameter r_val | <p class="shorttext synchronized" lang="EN">Exception text</p>
  methods text
            returning
              value(r_val) type string.

  "! <p class="shorttext synchronized" lang="EN">Returns the sequence of calls leading to this exception</p>
  "!
  "! @parameter r_val | <p class="shorttext synchronized" lang="EN">Call stack</p>
  methods stack_trace
            returning
              value(r_val) type ref to if_xco_cp_call_stack.

endinterface.
