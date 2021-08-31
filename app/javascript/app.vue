<template>
  <draggable :list="lists" group="lists" class="board dragArea" @end="listMoved">
    <list v-for="(list, index) in lists" :list="list"></list>

    <div class="edit-list">
      <a v-if="!editing" v-on:click="startEditing" >Add a list</a>
      <textarea v-if="editing" ref="message" v-model="message" class="form-control mb-3"></textarea>
      <button v-if="editing" v-on:click="createList" class="btn btn-secondary">Add</button>
      <a v-if="editing" v-on:click="editing=false" >Cancel</a>
    </div>

  </draggable>
</template>

<script>

import Rails from '@rails/ujs';
import draggable from 'vuedraggable';
import list from 'components/list';

export default {
  components: { draggable, list },

  data: function() {
    return {
      editing: false,
      message: "",
    }
  },

  computed: {
    lists() {
      return this.$store.state.lists;
    }
  },

  methods: {
     startEditing: function() {
      this.editing = true
      this.$nextTick(() => { this.$refs.message.focus() })
    },

    listMoved: function(event) {
      var data = new FormData
      data.append("list[position]", event.newIndex + 1)

      Rails.ajax({
        beforeSend: () => true,
        url: `/lists/${this.lists[event.newIndex].id}/move`,
        type: "PATCH",
        data: data,
        dataType: "json"
      })
    },

    createList: function() {
      var data = new FormData
      data.append("list[name]", this.message)

      Rails.ajax({
        url: "/lists",
        type: "POST",
        data: data,
        dataType: "json",
        success: (data) => {
          this.$store.commit('addList', data)
          this.message = ""
          this.editing = false
        }
      })
    },
  }
}
</script>

<style scoped>
.dragArea {
  min-height: 10px;
}

.board {
  white-space: nowrap;
  overflow-x: auto;
}

.container {
  margin-top: 20px;
}

.list {
  display: inline-block;
  margin-right: 20px;
  vertical-align: top;
  width: 270px;
  background: #d6d6d6;
  box-shadow: 1px 1px 1px 1px #251c24;
  border-radius: 3px;
  padding: 10px;
  margin-bottom: 50px;
}

.btn-secondary {
  background-color: #bc3a3a;
  font-weight: 600;
  border: none;
}

.btn-secondary:hover {
  background-color: #A93434;
  border: none;
}

.edit-list {
  display: inline-block;
  margin-right: 20px;
  vertical-align: top;
  width: 270px;
  background: #251c24;
  box-shadow: 1px 1px 1px 1px #fafafa;
  color: #fff;
  border-radius: 3px;
  padding: 10px;
}

a {
  color: #fafafa;
  margin-left: 5px;
  font-weight: 600;
  cursor: pointer;
}

a:hover {
  color: #fff !important;
  font-weight: 600;
  cursor: pointer;
}

</style>
