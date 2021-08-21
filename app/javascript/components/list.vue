<template>
  <div class="list">
    <div class="d-flex justify-content-between"><h6 class="text-center">{{ list.name.toUpperCase() }}</h6><a @click="editing=true" ><i class="fas fa-pen"></i></a></div>

    <draggable v-model="list.cards" group="cards"  class="dragArea" @end="cardMoved">
      <card v-for="card in list.cards" :card="card" :key="card.id" :list="list"></card>
    </draggable>

    <a v-if="!editing" v-on:click="startEditing">Add an activity</a>
      <textarea v-if="editing" ref="message" v-model="message" class="form-control mb-3"></textarea>
      <button v-if="editing" v-on:click="submitMessage" class="btn btn-secondary">Add</button>
    <a v-if="editing" v-on:click="editing=false" >Cancel</a>
  </div>
</template>

<script>
  import Rails from '@rails/ujs';
  import draggable from 'vuedraggable';
  import card from 'components/card';

  export default {
    components: { card, draggable },
    props: ["list"],

    data: function() {
      return {
        editing: false,
        message: "",
    }
  },

  methods: {
    startEditing: function() {
      this.editing = true
      this.$nextTick(() => { this.$refs.message.focus() })
    },

    submitMessage: function() {
      var data = new FormData
      data.append("card[list_id]", this.list.id)
      data.append("card[name]", this.message)

      Rails.ajax({
        url: "/cards",
        type: "POST",
        data: data,
        dataType: "json",
        success: (data) => {
          const index = window.store.lists.findIndex(item => item.id == this.list.id)
          window.store.lists[index].cards.push(data)
          this.message = ""
        }
      })
    },

    cardMoved: function(event) {
        const evt = event.added || event.moved
        if (evt == undefined) { return }
        const element = evt.element
        const list_index = window.store.state.lists.findIndex((list) => {
          return list.cards.find((card) => {
            return card.id === element.id
          })
        })
        var data = new FormData
        data.append("card[list_id]", window.store.state.lists[list_index].id)
        data.append("card[position]", evt.newIndex + 1)
        Rails.ajax({
          beforeSend: () => true,
          url: `/cards/${element.id}/move`,
          type: "PATCH",
          data: data,
          dataType: "json"
        })
      }
  },
}

</script>

<style scoped>
.btn-secondary {
  background-color: #bc3a3a;
  color: #fafafa;
  font-weight: 600;
  border: none;
  margin-right: 5px;
}

.btn-secondary:hover {
  background-color: #A93434;
  border: none;
}

</style>
